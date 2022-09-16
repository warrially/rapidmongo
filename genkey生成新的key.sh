echo "生成新KEY"
openssl rand -base64 756 > mongo0/configdb/mongodbKeyfile.key
echo "拷贝到其他目录"
cp mongo0/configdb/mongodbKeyfile.key mongo1/configdb/
cp mongo0/configdb/mongodbKeyfile.key mongo2/configdb/

echo "设置文件属性400"
chmod 400 mongo0/configdb/mongodbKeyfile.key 
chmod 400 mongo1/configdb/mongodbKeyfile.key 
chmod 400 mongo2/configdb/mongodbKeyfile.key 



echo "创建虚拟网络"
docker network create mongo-rs

echo "准备跑docker容器"
docker run -di --name=mongo0 -p 127.0.0.1:27017:27017 -p 127.0.0.1:27018:27018 -p 127.0.0.1:27019:27019 -v /root/rapidmongo/mongo0/configdb:/data/configdb/ -v /root/rapidmongo/mongo0/db/:/data/db/  mongo  --replSet "mongoRs" --bind_ip_all -f /data/configdb/mongod.conf 
docker run -di --name=mongo1 --net container:mongo0 -v /root/rapidmongo/mongo1/configdb:/data/configdb/ -v /root/rapidmongo/mongo1/db/:/data/db/  mongo  --replSet "mongoRs" --bind_ip_all -f /data/configdb/mongod.conf
docker run -di --name=mongo2 --net container:mongo0 -v /root/rapidmongo/mongo2/configdb:/data/configdb/ -v /root/rapidmongo/mongo2/db/:/data/db/  mongo  --replSet "mongoRs" --bind_ip_all -f /data/configdb/mongod.conf


# docker inspect mongo0 | grep IPAddress
# docker inspect mongo1 | grep IPAddress
# docker inspect mongo2 | grep IPAddress

# docker exec -it mongo0 mongo


# rs.initiate( { _id:"mongoRs", members:[ {_id:0,host:"192.168.1.2:27017"}, {_id:1,host:"192.168.1.9:47017"}, {_id:2,host:"192.168.1.9:57017"} ] } );
# rs.initiate( { _id:"mongoRs", members:[ {_id:0,host:"127.0.0.1:27017"}, {_id:1,host:"127.0.0.1:27018"}, {_id:2,host:"127.0.0.1:27019"} ] } );
# rs.initiate( { _id:"mongoRs", members:[ {_id:0,host:"172.17.0.2:27017"}, {_id:1,host:"172.17.0.3:27017"}, {_id:2,host:"172.17.0.4:27017"} ] } );


# docker stop mongo0 mongo1 mongo2
# docker rm mongo0 mongo1 mongo2

