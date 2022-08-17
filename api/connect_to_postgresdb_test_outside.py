import psycopg2

#establishing the connection
conn = psycopg2.connect(
   database="awesomeinc", user='interviewee', password='wannasucceed', host='127.0.0.1', port= '5432'
)
#Creating a cursor object using the cursor() method
cursor = conn.cursor()

#Executing an MYSQL function using the execute() method
print("get data from dimension")
cursor.execute("select * FROM public.\"DimCustomer\"")

# Fetch a single row using fetchone() method.
data = cursor.fetchone()
print("Connection established to: ",data)

#Closing the connection
conn.close()