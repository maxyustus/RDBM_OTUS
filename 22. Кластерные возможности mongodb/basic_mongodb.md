## Базовые возможности MongoDB

---

* Скачаем image mongo. Код не будет переиспользоваться, так что latest ок. Запустим контейнер в detached режиме. Утилитой 'cp' скопируем туда небольшой датасет в json. Импортируем датасет утилитой 'mongoimport'.
```
docker pull mongo
docker run -it --rm --name mongodb -d mongo
docker cp /Users/maxyustus/Desktop/countries-small.json mongodb:/tmp/countries-small.json
docker exec mongodb mongoimport -d countrydb -c country --file /tmp/countries-small.json
```


* Подключимся к mongo shell.
```
docker exec -it mongodb mongo
```
* Посмотрим базы, коллекции, убедимся, что наш датасет на месте. Выведем информацию о нашей коллекции, напишем пару тестовых запросов на выборку данных.
```
show dbs

use countrydb

show collections

db.getCollectionInfos();

db.country.find().limit(1)

db.country.find({"area" : 91})
```
* Посмотрим, какие индексы уже есть. Посмотрев структуру документа, заметил, что регионов неожиданно много. Решил добавить индекс на одно поле, 'region', чтобы ускорить поиск стран по региону. Посмотрим на план запроса до создания индекса.
```
db.country.getIndexes()

db.country.explain().find({"region" : "Americas"})
{
	"explainVersion" : "1",
	"queryPlanner" : {
		"namespace" : "countrydb.country",
		"indexFilterSet" : false,
		"parsedQuery" : {
			"region" : {
				"$eq" : "Americas"
			}
		},
		"queryHash" : "0D0DD013",
		"planCacheKey" : "340BBF52",
		"maxIndexedOrSolutionsReached" : false,
		"maxIndexedAndSolutionsReached" : false,
		"maxScansToExplodeReached" : false,
		"winningPlan" : {
			"stage" : "COLLSCAN",
			"filter" : {
				"region" : {
					"$eq" : "Americas"
				}
			},
			"direction" : "forward"
		},
		"rejectedPlans" : [ ]
	},
	"command" : {
		"find" : "country",
		"filter" : {
			"region" : "Americas"
		},
		"$db" : "countrydb"
	},
	"serverInfo" : {
		"host" : "7704bf98ef58",
		"port" : 27017,
		"version" : "5.0.5",
		"gitVersion" : "d65fd89df3fc039b5c55933c0f71d647a54510ae"
	},
	"serverParameters" : {
		"internalQueryFacetBufferSizeBytes" : 104857600,
		"internalQueryFacetMaxOutputDocSizeBytes" : 104857600,
		"internalLookupStageIntermediateDocumentMaxSizeBytes" : 104857600,
		"internalDocumentSourceGroupMaxMemoryBytes" : 104857600,
		"internalQueryMaxBlockingSortMemoryUsageBytes" : 104857600,
		"internalQueryProhibitBlockingMergeOnMongoS" : 0,
		"internalQueryMaxAddToSetBytes" : 104857600,
		"internalDocumentSourceSetWindowFieldsMaxMemoryBytes" : 104857600
	},
	"ok" : 1
}

db.country.createIndex({email : 1})
```
* Посмотрим план запроса после создания индекса. Теперь видим "IXSCAN" вместо "COLLSCAN". 
```
db.country.explain().find({"region" : "Americas"})
{
	"explainVersion" : "1",
	"queryPlanner" : {
		"namespace" : "countrydb.country",
		"indexFilterSet" : false,
		"parsedQuery" : {
			"region" : {
				"$eq" : "Americas"
			}
		},
		"queryHash" : "0D0DD013",
		"planCacheKey" : "ADDCC336",
		"maxIndexedOrSolutionsReached" : false,
		"maxIndexedAndSolutionsReached" : false,
		"maxScansToExplodeReached" : false,
		"winningPlan" : {
			"stage" : "FETCH",
			"inputStage" : {
				"stage" : "IXSCAN",
				"keyPattern" : {
					"region" : 1
				},
				"indexName" : "region_1",
				"isMultiKey" : false,
				"multiKeyPaths" : {
					"region" : [ ]
				},
				"isUnique" : false,
				"isSparse" : false,
				"isPartial" : false,
				"indexVersion" : 2,
				"direction" : "forward",
				"indexBounds" : {
					"region" : [
						"[\"Americas\", \"Americas\"]"
					]
				}
			}
		},
		"rejectedPlans" : [ ]
	},
	"command" : {
		"find" : "country",
		"filter" : {
			"region" : "Americas"
		},
		"$db" : "countrydb"
	},
	"serverInfo" : {
		"host" : "7704bf98ef58",
		"port" : 27017,
		"version" : "5.0.5",
		"gitVersion" : "d65fd89df3fc039b5c55933c0f71d647a54510ae"
	},
	"serverParameters" : {
		"internalQueryFacetBufferSizeBytes" : 104857600,
		"internalQueryFacetMaxOutputDocSizeBytes" : 104857600,
		"internalLookupStageIntermediateDocumentMaxSizeBytes" : 104857600,
		"internalDocumentSourceGroupMaxMemoryBytes" : 104857600,
		"internalQueryMaxBlockingSortMemoryUsageBytes" : 104857600,
		"internalQueryProhibitBlockingMergeOnMongoS" : 0,
		"internalQueryMaxAddToSetBytes" : 104857600,
		"internalDocumentSourceSetWindowFieldsMaxMemoryBytes" : 104857600
	},
	"ok" : 1
}
```
* Обновим какие-нибудь данные. 

**Как нельзя обновлять данные. Затрёт весь документ.**
```
db.country.update({_id : ObjectId('55a0f42f20a4d760b5fc305f')}, {"landlocked": false})

db.country.find().limit(1)
```

* Как обновить значения в поле правильно.
```
db.country.update({_id : ObjectId("55a0f42f20a4d760b5fc305e")}, {$set: {"landlocked": true}})

db.country.find().limit(1).skip(1)
```

* Удалим вообще все документы из коллекции
```
db.country.deleteMany({})
{ "acknowledged" : true, "deletedCount" : 248 }

db.country.find()

docker rm --force mongodb
```
