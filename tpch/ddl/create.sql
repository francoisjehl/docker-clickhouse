CREATE TABLE IF NOT EXISTS lineorder (
      LO_ORDERKEY             UInt32,
      LO_LINENUMBER           UInt8,
      LO_CUSTKEY              UInt32,
      LO_PARTKEY              UInt32,
      LO_SUPPKEY              UInt32,
      LO_ORDERDATE            Date,
      LO_ORDERPRIORITY        String,
      LO_SHIPPRIORITY         UInt8,
      LO_QUANTITY             UInt8,
      LO_EXTENDEDPRICE        UInt32,
      LO_ORDTOTALPRICE        UInt32,
      LO_DISCOUNT             UInt8,
      LO_REVENUE              UInt32,
      LO_SUPPLYCOST           UInt32,
      LO_TAX                  UInt8,
      LO_COMMITDATE           Date,
      LO_SHIPMODE             String
) 
Engine=ReplicatedMergeTree('/clickhouse/{cluster}/tables/lineorder/shards/{shard}', '{replica}', LO_ORDERDATE,(LO_ORDERKEY,LO_LINENUMBER,LO_ORDERDATE),8192);
    
CREATE TABLE IF NOT EXISTS customer (
      C_CUSTKEY       UInt32,
      C_NAME          String,
      C_ADDRESS       String,
      C_CITY          String,
      C_NATION        String,
      C_REGION        String,
      C_PHONE         String,
      C_MKTSEGMENT    String,
      C_FAKEDATE      Date
)
Engine=ReplicatedMergeTree('/clickhouse/{cluster}/tables/customer', '{replica}', C_FAKEDATE,(C_CUSTKEY,C_FAKEDATE),8192);

CREATE TABLE IF NOT EXISTS part (
      P_PARTKEY       UInt32,
      P_NAME          String,
      P_MFGR          String,
      P_CATEGORY      String,
      P_BRAND         String,
      P_COLOR         String,
      P_TYPE          String,
      P_SIZE          UInt8,
      P_CONTAINER     String,
      P_FAKEDATE      Date
)
Engine=ReplicatedMergeTree('/clickhouse/{cluster}/tables/part', '{replica}', P_FAKEDATE,(P_PARTKEY,P_FAKEDATE),8192);

CREATE TABLE IF NOT EXISTS lineorderd AS lineorder ENGINE = Distributed(docker, default, lineorder, rand());
