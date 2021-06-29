const MongoClient = require("mongodb").MongoClient;
const fs = require("fs");
const aws = require("aws-sdk");
const pLimit = require("p-limit");
const util = require("util");

const dbName = "inklink-scrape";

const limit = pLimit(128);

var ep = new aws.Endpoint("s3.us-west-000.backblazeb2.com");
var s3 = new aws.S3({ endpoint: ep, region: "us-west-000" });

var credentials = new aws.SharedIniFileCredentials({ profile: "b2" });
s3.config.credentials = credentials;

var bucketName = "inklink-ig-scrape";

var ca = [fs.readFileSync(__dirname + "/ya.crt")];

const url = util.format(
  "mongodb://%s:%s@%s/?replicaSet=%s&authSource=%s&ssl=true",
  process.env.mongoUser,
  process.env.mongoPassword,
  [process.env.mongoUrl].join(","),
  "rs01",
  "db1"
);

(async () => {
  let client;
  try {
    client = await MongoClient.connect(url, {
      useNewUrlParser: true,
      replSet: {
        sslCA: ca,
      },
    });
  } catch (err) {
    throw new Error(err);
  }
  const db = client.db(dbName);
  const col = db.collection("posts");

  const posts = [];

  const cur = col.aggregate(JSON.parse(process.env.mongoQuery) ?? [], {
    allowDiskUse: true,
  });

  await cur.forEach((d) =>
    d.posts.forEach((p) => posts.push({ timestamp: p, ownerUsername: d._id }))
  );

  fs.mkdirSync("./dataset");

  const ps = posts.map((doc) =>
    limit(
      () =>
        new Promise(async (resolve, reject) => {
          const fileId =
            doc.ownerUsername + "/" + +new Date(doc.timestamp) + "_0.jpg";

          const fileName =
            doc.ownerUsername + "_" + +new Date(doc.timestamp) + "_0.jpg";

          console.log("download ", fileName);

          var file = fs.createWriteStream("./dataset/" + fileName);
          await new Promise((rs, rj) => {
            s3.getObject({ Bucket: bucketName, Key: fileId })
              .createReadStream()
              .on("end", () => {
                rs();
              })
              .on("error", (error) => {
                rj(error);
              })
              .pipe(file);
          })
            .then(() => resolve())
            .catch(() => reject());
        })
    )
  );

  Promise.allSettled(ps).then(() => {
    console.log("finish");
    process.exit(0);
  });
})();
