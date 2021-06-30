from pytorch/pytorch:1.7.1-cuda11.0-cudnn8-runtime

COPY . /app
WORKDIR /app

RUN pip install b2 
RUN apt update && apt install -y zip htop screen libgl1-mesa-glx git curl libglib2.0-0 

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash 
ENV NVM_DIR="/root/.nvm" 
RUN [ -s "$NVM_DIR/nvm.sh" ] . "$NVM_DIR/nvm.sh" 
RUN nvm install 15 
RUN nvm use 15 

RUN git clone https://github.com/kompaakt/inklink-label-img 
WORKDIR /app/inklink-label-img 
RUN npm i 
RUN git clone https://github.com/ultralytics/yolov5 
RUN pip install --no-cache -r /app/inklink-label-img/yolov5/requirements.txt coremltools onnx gsutil notebook 

RUN b2 authorize-account 0002f9f71c82a7b0000000005 K000fZGKr2YrCkqM5O5FFhStPeDpdEs 
RUN b2 download-file-by-id 4_z320fd9ffd7315c9872aa071b_f2049065d3b45ca04_d20210629_m221759_c000_v0001081_t0009 model.pt 

RUN mkdir ~/.aws 
RUN echo $'[b2]\naws_access_key_id = 0002f9f71c82a7b0000000003\naws_secret_access_key = K000GOP3saA+kL4dSIx0P0RVCiBgAvc' > ~/.aws/credentials 

ENV MONGO_USER=lowenssiivo 
ENV MONGO_PASSWORD=wastlendars17788 
ENV MONGO_HOST=rc1b-hv4qafrtycm3zken.mdb.yandexcloud.net:27018 
ENV MONGO_QUERY='[{"$match":{"linkExpired":{"$exists":false}}},{"$limit":1000000},{"$group":{"_id":"$ownerUsername","posts":{"$addToSet":"$timestamp"}}},{"$sample":{"size":100}}]' 


# RUN node $(pwd)/download-sample-posts.js 
# RUN python $(pwd)/yolov5/detect.py --source $(pwd)/dataset --weights $(pwd)/model.pt --conf 0.6 --save-txt --augment 

# RUN mv $(pwd)/runs/detect/exp/labels $(pwd)/labels

# RUN node ./upload-bbox.js

# pip install b2 
# apt update && apt install -y zip htop screen libgl1-mesa-glx git curl libglib2.0-0 

# curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash 
# export NVM_DIR="/root/.nvm" 
# [ -s "$NVM_DIR/nvm.sh" ] . "$NVM_DIR/nvm.sh" 
# nvm install 15 
# nvm use 15 

# git clone https://github.com/kompaakt/inklink-label-img 
# cd inklink-label-img 
# npm i 
# git clone https://github.com/ultralytics/yolov5 
# pip install --no-cache -r $(pwd)/yolov5/requirements.txt coremltools onnx gsutil notebook 

# b2 authorize-account 0002f9f71c82a7b0000000005 K000fZGKr2YrCkqM5O5FFhStPeDpdEs 
# b2 download-file-by-id 4_z320fd9ffd7315c9872aa071b_f2049065d3b45ca04_d20210629_m221759_c000_v0001081_t0009 model.pt 

# mkdir ~/.aws 
# echo $'[b2]\naws_access_key_id = 0002f9f71c82a7b0000000003\naws_secret_access_key = K000GOP3saA+kL4dSIx0P0RVCiBgAvc' > ~/.aws/credentials 

# export MONGO_USER=lowenssiivo 
# export MONGO_PASSWORD=wastlendars17788 
# export MONGO_HOST=rc1b-hv4qafrtycm3zken.mdb.yandexcloud.net:27018 
# export MONGO_QUERY='[{"$match":{"linkExpired":{"$exists":false}}},{"$limit":1000000},{"$group":{"_id":"$ownerUsername","posts":{"$addToSet":"$timestamp"}}},{"$sample":{"size":100}}]' 

# cd inklink-label-img

# node $(pwd)/download-sample-posts.js 
# python $(pwd)/yolov5/detect.py --source $(pwd)/dataset --weights $(pwd)/model.pt --conf 0.6 --save-txt --augment 

# mv $(pwd)/runs/detect/exp/labels $(pwd)/labels

# node ./upload-bbox.js

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