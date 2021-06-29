from pytorch/pytorch:1.7.1-cuda11.0-cudnn8-runtime

COPY . /app

RUN pip install b2
RUN apt update && apt install -y zip htop screen libgl1-mesa-glx
RUN pip install --no-cache -r requirements.txt coremltools onnx gsutil notebook
RUN apt install \
  bash \
  nodejs \
  npm

RUN npm ci

WORKDIR /app

RUN b2 authorize-account $B2_KEY_ID $B2_APPLICATION_KEY
RUN b2 download-file-by-id $ML_MODEL_FILE_ID model.pt
RUN node ./download-sample-posts.mjs
RUN python /usr/src/app/detect.py --source /app/dataset --weights /app/model.pt --conf 0.6 --save-txt --augment
RUN node ./upload-results.mjs

pip install b2 && \
apt update && apt install -y zip htop screen libgl1-mesa-glx git nodejs npm && \
git clone https://github.com/kompaakt/inklink-label-img && \
npm ci && \
cd inklink-label-img && \
git clone https://github.com/ultralytics/yolov5 && \
pip install --no-cache -r requirements.txt coremltools onnx gsutil notebook  && \
b2 authorize-account 0002f9f71c82a7b0000000005 K000fZGKr2YrCkqM5O5FFhStPeDpdEs && \
b2 download-file-by-id 4_z320fd9ffd7315c9872aa071b_f2049065d3b45ca04_d20210629_m221759_c000_v0001081_t0009 model.pt && \
export MONGO_USER=lowenssiivo
export MONGO_PASSWORD=wastlendars17788 
export MONGO_HOST=rc1b-hv4qafrtycm3zken.mdb.yandexcloud.net:27018
export MONGO_QUERY='[{"$match":{"linkExpired":{"$exists":false}}},{"$limit":1000000},{"$group":{"_id":"$ownerUsername","posts":{"$addToSet":"$timestamp"}}},{"$sample":{"size":100}}]'
node $(pwd)/download-sample-posts.js && \
python $(pwd)/yolov5/detect.py --source $(pwd)/dataset --weights $(pwd)/model.pt --conf 0.6 --save-txt --augment && \
# node ./upload-results.mjs && \

# RUN zx ./download-sample-posts.mjs
# RUN tar czf labels.tar.gz /usr/src/app/runs/detect/exp/labels


#     1  apt install git
#     2  RUN apt update && apt install -y zip htop screen libgl1-mesa-glx
#     3  git clone https://github.com/ultralytics/yolov5/
#     4  cd yolov5/
#     5  pip uninstall -y nvidia-tensorboard nvidia-tensorboard-plugin-dlprof
#     6  pip install --no-cache -r requirements.txt coremltools onnx gsutil notebook
#     7  pip install --no-cache -U torch torchvision numpy
#     8  python detect.py
#     9  sudo apt-get install libglib2.0-0
#    10  python detect.py
#    11  history

'[{ \\$limit: 1000000 },{\\$group: {"_id": \\$ownerUsername,"posts": {\\$addToSet: \\$timestamp}}},{\\$sample: {"size": 100}}]'