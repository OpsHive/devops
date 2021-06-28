		Cron Jobs in k8s

cron jobs are jobs that can be schedule at specific time like linux cron tab if you 
familiar with that

apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: reporting-cron-job
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      completions: 3
      parallelism: 3
      template:
        spec:
          containers:
          - name: reporting-tool
            image: reporting-tool
          restartPolicy: Never

---------------------------------------------

what acctually staric (*) means

 * * * * *

first staric		minuts (0-59)
second staric		hours (0-23)
third staric		days (1-31)
fourth staric		months (1-12)
fifth staric		week days(1-6)

