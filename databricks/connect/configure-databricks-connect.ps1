#.\venv\Scripts\activate

python -m pip install --upgrade pip

python -m pip show pyspark
python -m pip uninstall pyspark

$DatabricksRuntimeVersion = Read-Host "Please, enter your databricks runtime version, for example: 13.3"

python -m pip install --upgrade "databricks-connect==$DatabricksRuntimeVersion.*"

python -m pip show databricks-connect
databricks -v
databricks auth profiles

$DatabricksHost = Read-Host "Please, enter your databricks host"

# use token authentication if this doesn't work
databricks auth login --configure-cluster --host $DatabricksHost --profile DEV --output json

databricks auth env --profile DEV --output json
