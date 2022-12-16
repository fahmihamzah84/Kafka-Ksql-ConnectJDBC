#### MAKE A CONNECTION TO POSTGRES DB

```bash
CREATE SOURCE CONNECTOR jdbc_source WITH (
  'connector.class'          = 'io.confluent.connect.jdbc.JdbcSourceConnector',
  'connection.url'           = 'jdbc:postgresql://postgres:5432/postgres',
  'connection.user'          = 'postgres',
  'connection.password'      = 'postgres',
  'topic.prefix'             = 'jdbc_',
  'table.whitelist'          = 'company',
  'mode'                     = 'incrementing',
  'numeric.mapping'          = 'best_fit',
  'incrementing.column.name' = 'id',
  'key'                      = 'id',
  'key.converter'            = 'org.apache.kafka.connect.converters.IntegerConverter');
```

#### CREATE STREAM TABLE
```bash
CREATE STREAM stream_table (
   id INTEGER KEY,
   name VARCHAR,
   AGE INT,
   ADDRESS STRING(50),
   SALARY DOUBLE,
   DEPARTMENT VARCHAR,
   JOIN_DATE DATE)

WITH (kafka_topic='employment',
    partitions = 1,
    value_format = 'json');
```

#### CREATE TABLE final_table
```bash
CREATE TABLE final_table AS
   SELECT DEPARTMENT,
	    AVG(salary)
   FROM stream_table 
   GROUP BY DEPARTMENT
   EMIT CHANGES;
```

#### PUSH QUERY
```bash
INSERT INTO STREAM_TABLE (ID,NAME,AGE,ADDRESS,DEPARTMENT, SALARY,JOIN_DATE) VALUES (2, 'Andre', 23, 'Texas','Sales', 33000.00,'2021-02-15');
INSERT INTO STREAM_TABLE (ID,NAME,AGE,ADDRESS,DEPARTMENT, SALARY,JOIN_DATE) VALUES (3, 'KSI', 25, 'Norway','IT', 52300.00,'2006-07-12');
INSERT INTO STREAM_TABLE (ID,NAME,AGE,ADDRESS,DEPARTMENT, SALARY,JOIN_DATE) VALUES (4, 'Logan', 22, 'Rich-Mond','IT', 14000.00,'2017-12-13');
INSERT INTO STREAM_TABLE (ID,NAME,AGE,ADDRESS,DEPARTMENT, SALARY,JOIN_DATE) VALUES (5, 'Adin', 35, 'Kuningan','Sales', 25600.00,'2018-04-12');
INSERT INTO STREAM_TABLE (ID,NAME,AGE,ADDRESS,DEPARTMENT, SALARY,JOIN_DATE) VALUES (6, 'Chunkz', 43, 'Jakarta','Marketing', 34600.00,'2022-09-23');
INSERT INTO STREAM_TABLE (ID,NAME,AGE,ADDRESS,DEPARTMENT, SALARY,JOIN_DATE) VALUES (7, 'Niko', 28, 'Bandung','Marketing', 34000.00,'2021-07-01');
```


#### EXPORT FROM KAFKA TO POSTGRES 
```bash
CREATE SINK CONNECTOR jdbc_sink WITH (
  'connector.class'          = 'io.confluent.connect.jdbc.JdbcSinkConnector',
  'connection.url'           = 'jdbc:postgresql://postgres:5432/',
  'connection.user'          = 'postgres',
  'connection.password'      = 'postgres',
  'topics'             	     = 'final_table',
  'key.converter.schemas.enable'= 'false',
  'value.converter.schemas.enable'= 'true',
  'value.converter'= 'org.apache.kafka.connect.json.JsonConverter',
  'key.converter'= 'org.apache.kafka.connect.storage.StringConverter'
  'auto.create'= 'true',
  'auto.evolve'= 'true',
  'table.name.format'= '${topic}-01');
```

