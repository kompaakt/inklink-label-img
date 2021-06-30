const MongoClient = require("mongodb").MongoClient;
const fs = require("fs");
const util = require("util");

const dbName = "inklink-scrape";

var ca = [fs.readFileSync(__dirname + "/ya.crt")];

const url = util.format(
  "mongodb://%s:%s@%s/?replicaSet=%s&authSource=%s&ssl=true",
  process.env.MONGO_USER,
  process.env.MONGO_PASSWORD,
  [process.env.MONGO_HOST].join(","),
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
  const col = db.collection("pictures");

  const currentDir = process.cwd();

  const pics = [];

  fs.readdir("./labels", async (err, files) => {
    await new Promise((resolve) => {
      files.forEach(async (file) => {
        const [, timestamp] = file.match(/_\d{13}/g)[0].split("_");
        const ownerUsername = file.split(/_\d{13}/g)[0];

        const tattoos = [];
        const data = fs
          .readFileSync(currentDir + "/" + "labels" + "/" + file, "utf8")
          .toString();

        const lines = data.trim().split("\n");
        lines.forEach((line) => {
          console.log(line);
          const [, cx, cy, w, h] = line.split(" ");
          tattoos.push({ cx, cy, w, h });
        });

        const pic = {
          ownerUsername,
          timestamp,
          tattoos,
        };

        pics.push(pic);
        resolve();
      });
    });
    col.insertMany(pics).then(() => process.exit(0));
  });
})();
