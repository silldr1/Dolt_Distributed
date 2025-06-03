# Dolt_Distributed

Building a Dolt Distributed database to try to model and simulate bad network conditions and test backend


# Real Data Branch

Create a folder /opt/sql_dumps/
Copy bootstrap into there

Put all sql dumps into that directory

If you ever want to start fresh:

```
rm /opt/dolt/mydb/.processed_sql_files
docker restart local-node
```

