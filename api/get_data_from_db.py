import psycopg2
import sys

try:
#establishing the connection
    connection = psycopg2.connect(
     database="awesomeinc", user='interviewee', password='wannasucceed', host='postgres', port= '5432'
    )
    #Create a cursor object
    cursor = connection.cursor()
    print("get data from table or view : name = "+sys.argv[1])
    cursor.execute("select * FROM "+sys.argv[1])
    data = cursor.fetchall()
    # print(data)
    for row in data:
            print(row)
    cursor.close()
except (Exception, psycopg2.Error) as error:
    print("Error while fetching data from PostgreSQL", error)
finally:
    # closing database connection.
    if connection:
        connection.close()
        print("PostgreSQL connection is closed")