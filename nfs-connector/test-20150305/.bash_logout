echo "Clean up test data directories."
hadoop fs -rm -r -f /user/root/*
hadoop fs -rm -r -f /user/testuser/*
hadoop fs -rm -r -f /user/hoge/*
hadoop fs -rm -r -f /hadoopvol1/*
hadoop fs -rm -r -f /hadoopvol2/*
echo "Clean up complete."
