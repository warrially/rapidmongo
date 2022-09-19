# 生成新KEY 
```bash
openssl rand -base64 756 > mongo0/configdb/mongodbKeyfile.key
```
# 拷贝到其他目录
```bash
cp mongo0/configdb/mongodbKeyfile.key mongo1/configdb/
cp mongo0/configdb/mongodbKeyfile.key mongo2/configdb/
```

# 设置文件属性400
```bash
chmod 400 mongo0/configdb/mongodbKeyfile.key 
chmod 400 mongo1/configdb/mongodbKeyfile.key 
chmod 400 mongo2/configdb/mongodbKeyfile.key 
```



# 创建虚拟网络
```bash
docker network create mongo-rs
```

# 准备跑docker容器
```bash
docker run -di --restart=always --name=mongo0 -p 127.0.0.1:27017:27017 -p 127.0.0.1:27018:27018 -p 127.0.0.1:27019:27019 -v /root/rapidmongo/mongo0/configdb:/data/configdb/ -v /root/rapidmongo/mongo0/db/:/data/db/  mongo:5  --replSet "mongoRs" --bind_ip_all -f /data/configdb/mongod.conf 
docker run -di --restart=always --name=mongo1 --net container:mongo0 -v /root/rapidmongo/mongo1/configdb:/data/configdb/ -v /root/rapidmongo/mongo1/db/:/data/db/  mongo:5  --replSet "mongoRs" --bind_ip_all -f /data/configdb/mongod.conf
docker run -di --restart=always --name=mongo2 --net container:mongo0 -v /root/rapidmongo/mongo2/configdb:/data/configdb/ -v /root/rapidmongo/mongo2/db/:/data/db/  mongo:5  --replSet "mongoRs" --bind_ip_all -f /data/configdb/mongod.conf
```

# docker 查看IP地址,  这里无用
```bash
docker inspect mongo0 | grep IPAddress
docker inspect mongo1 | grep IPAddress
docker inspect mongo2 | grep IPAddress
```


# 进入docker 执行命令
```bash
docker exec -it mongo0 mongo
```


# 3个副本集命令在这里
```mongodb
rs.initiate( { _id:"mongoRs", members:[ {_id:0,host:"127.0.0.1:27017"}, {_id:1,host:"127.0.0.1:27018"}, {_id:2,host:"127.0.0.1:27019"} ] } );
```

# 创建用户
```mongodb
use admin
db.createUser({user:"root", pwd:"123456", roles:[{role:"root",db:"admin"}]});
```

# 用来关闭服务器内容
```bash
docker stop mongo0 mongo1 mongo2
docker rm mongo0 mongo1 mongo2
```
