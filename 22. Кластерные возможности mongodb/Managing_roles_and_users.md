#### Создаём роли и пользователей в system:

```db = db.getSiblingDB("admin")
db.createRole(
    {      
     role: "superRoot",      
     privileges:[
        { resource: {anyResource:true}, actions: ["anyAction"]}
     ],      
     roles:[] 
    }
)

db.createUser({
     user: "readonlyuser",
     pwd: "uNLoCK*0NLyReaD", 
     roles: [{role:"read", db: ["databaselist"]}]})


db.createUser({      
     user: "companyDBA",      
     pwd: "EWqeeFpUt9*8zq",      
     roles: ["superRoot"] 
})

use admin
```

##### Проверим созданные роли и пользователей.

```
db.system.roles.find()
db.system.users.find()

Выполним shutdown()
db.shutdownServer()
```
##### Перезапустим сервер с аутентификацией, для этого форкнем процесс:

```
mongod --dbpath /home/mongo/db1 --port 27001 --auth --fork --logpath /home/mongo/db1/db1.log --pidfilepath /home/mongo/db1/db1.pid
```

##### Заходим без указания юзера и пароля - никаких данных не прочитаем.
```
mongo --port 27001
```

##### Теперь зайдём с указанием юзера, пароля и базы данных, на которую выданы привилегии.

```
mongo --port 27001 -u readonlyuser -p uNLoCK*0NLyReaD --authenticationDatabase "<availabledatabase>"
```

##### readonlyuser назначена встроенная роль “read” на список баз. Ему доступны только для чтения.

```
show databases
```
