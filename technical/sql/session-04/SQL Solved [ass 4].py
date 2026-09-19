import psycopg2 

try :
    connection = psycopg2.connect(
        host = "localhost" ,
        user = "postgres" ,
        database = "Your name Database" ,  # focus on
        password = "Your password"         # focus on
    )
    print("connection to the database established successfully :)")

except Exception as e :
    print(f"Error Connection database : {e}")

cursor = connection.cursor()


cursor.execute(
"""
       CREATE TABLE IF NOT EXISTS DEPARTMENT(
       department_id SERIAL PRIMARY KEY ,
       department_name VARCHAR(50) NOT NULL ,
       location VARCHAR(50)
       ) 
"""
)

cursor.execute(
"""
       CREATE TABLE IF NOT EXISTS STUDENT(
       student_id SERIAL NOT NULL PRIMARY KEY ,
       first_name VARCHAR(30) NOT NULL ,
       last_name VARCHAR(30) ,
       birth_date DATE ,
       gender CHAR(1) ,
       email VARCHAR(100) UNIQUE ,
       phone VARCHAR(20) ,
       department_id INTEGER REFERENCES DEPARTMENT(department_id)
       )
"""
)

cursor.execute(
"""
       CREATE TABLE IF NOT EXISTS INSTRUCTOR(
       instructor_id SERIAL PRIMARY KEY ,
       first_name VARCHAR(30) NOT NULL ,
       last_name VARCHAR(30) ,
       email VARCHAR(100) UNIQUE ,
       department_id INTEGER REFERENCES DEPARTMENT(department_id)
    )
"""    
)

cursor.execute(
"""
       CREATE TABLE IF NOT EXISTS COURSE(
       course_id SERIAL PRIMARY KEY ,
       course_name VARCHAR(100) NOT NULL ,
       credit_hours INTEGER ,
       department_id INTEGER REFERENCES DEPARTMENT(department_id) ,
       instructor_id INTEGER REFERENCES INSTRUCTOR(instructor_id)
       )
"""    
)

cursor.execute(
"""
       CREATE TABLE IF NOT EXISTS ENROLLMENT(
        enrollment_id SERIAL PRIMARY KEY ,
        grade NUMERIC(5,2) ,
        semester VARCHAR(20)  ,
        course_id INTEGER  REFERENCES COURSE(course_id),
        student_id INTEGER  REFERENCES STUDENT(student_id) ,
        UNIQUE (student_id , course_id , semester)
        )
"""
)

connection.commit()



# ============================================================

connection.rollback()

cursor.execute("""
    TRUNCATE TABLE enrollment, course, student, instructor, department
    RESTART IDENTITY CASCADE
""")

connection.commit()

# ============================================================