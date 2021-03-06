/*
Navicat PGSQL Data Transfer

Source Server         : localhost_5432
Source Server Version : 90506
Source Host           : localhost:5432
Source Database       : dataman_storage
Source Schema         : public

Target Server Type    : PGSQL
Target Server Version : 90506
File Encoding         : 65001

Date: 2017-03-19 07:45:34
*/


-- ----------------------------
-- Sequence structure for database_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."database_id_seq";
CREATE SEQUENCE "public"."database_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 35
 CACHE 1;
SELECT setval('"public"."database_id_seq"', 35, true);

-- ----------------------------
-- Sequence structure for schema_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."schema_id_seq";
CREATE SEQUENCE "public"."schema_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 1
 CACHE 1;

-- ----------------------------
-- Sequence structure for table_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."table_id_seq";
CREATE SEQUENCE "public"."table_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 35
 CACHE 1;
SELECT setval('"public"."table_id_seq"', 35, true);

-- ----------------------------
-- Sequence structure for table_index_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."table_index_id_seq";
CREATE SEQUENCE "public"."table_index_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 1
 CACHE 1;

-- ----------------------------
-- Table structure for database
-- ----------------------------
DROP TABLE IF EXISTS "public"."database";
CREATE TABLE "public"."database" (
"id" int4 DEFAULT nextval('database_id_seq'::regclass) NOT NULL,
"name" varchar(255) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for schema
-- ----------------------------
DROP TABLE IF EXISTS "public"."schema";
CREATE TABLE "public"."schema" (
"id" int4 DEFAULT nextval('schema_id_seq'::regclass) NOT NULL,
"name" varchar(255) COLLATE "default" NOT NULL,
"version" int4 NOT NULL,
"data_json" text COLLATE "default" NOT NULL,
"backwards_compatible" int2
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for table
-- ----------------------------
DROP TABLE IF EXISTS "public"."table";
CREATE TABLE "public"."table" (
"id" int4 DEFAULT nextval('table_id_seq'::regclass) NOT NULL,
"name" varchar(255) COLLATE "default" NOT NULL,
"document_schema_id" int4,
"database_id" int4
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for table_index
-- ----------------------------
DROP TABLE IF EXISTS "public"."table_index";
CREATE TABLE "public"."table_index" (
"id" int4 DEFAULT nextval('table_index_id_seq'::regclass) NOT NULL,
"name" varchar(255) COLLATE "default" NOT NULL,
"table_id" int4 NOT NULL,
"data_json" jsonb
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------
ALTER SEQUENCE "public"."database_id_seq" OWNED BY "database"."id";
ALTER SEQUENCE "public"."schema_id_seq" OWNED BY "schema"."id";
ALTER SEQUENCE "public"."table_id_seq" OWNED BY "table"."id";
ALTER SEQUENCE "public"."table_index_id_seq" OWNED BY "table_index"."id";

-- ----------------------------
-- Indexes structure for table database
-- ----------------------------
CREATE UNIQUE INDEX "name" ON "public"."database" USING btree ("name");

-- ----------------------------
-- Primary Key structure for table database
-- ----------------------------
ALTER TABLE "public"."database" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table schema
-- ----------------------------
CREATE UNIQUE INDEX "name_version" ON "public"."schema" USING btree ("name", "version");

-- ----------------------------
-- Primary Key structure for table schema
-- ----------------------------
ALTER TABLE "public"."schema" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table table
-- ----------------------------
CREATE UNIQUE INDEX "table_name" ON "public"."table" USING btree ("name", "database_id");

-- ----------------------------
-- Primary Key structure for table table
-- ----------------------------
ALTER TABLE "public"."table" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table table_index
-- ----------------------------
CREATE UNIQUE INDEX "table_index_table" ON "public"."table_index" USING btree ("name", "table_id");

-- ----------------------------
-- Primary Key structure for table table_index
-- ----------------------------
ALTER TABLE "public"."table_index" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Key structure for table "public"."table"
-- ----------------------------
ALTER TABLE "public"."table" ADD FOREIGN KEY ("database_id") REFERENCES "public"."database" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."table" ADD FOREIGN KEY ("document_schema_id") REFERENCES "public"."schema" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Key structure for table "public"."table_index"
-- ----------------------------
ALTER TABLE "public"."table_index" ADD FOREIGN KEY ("table_id") REFERENCES "public"."table" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
