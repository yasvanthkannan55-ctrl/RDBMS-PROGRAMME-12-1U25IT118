import sqlite3
import pytest

@pytest.fixture(scope="module")
def db_conn():
    conn = sqlite3.connect(":memory:")
    cursor = conn.cursor()
    cursor.execute("PRAGMA foreign_keys = ON;")
    
    with open("schema.sql", "r") as f:
        schema_script = f.read()
    
    cursor.executescript(schema_script)
    yield conn
    conn.close()

def get_tables(conn):
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    return [row[0] for row in cursor.fetchall()]

def get_foreign_keys(conn, table_name):
    cursor = conn.cursor()
    cursor.execute(f"PRAGMA foreign_key_list('{table_name}');")
    return cursor.fetchall()

def test_tables_exist(db_conn):
    tables = get_tables(db_conn)
    expected = ["Department", "Faculty", "Student", "Course", "Enrollment"]
    for table in expected:
        assert table in tables, f"Missing table: {table}"

def test_department_student_1_to_many(db_conn):
    fks = get_foreign_keys(db_conn, "Student")
    referenced_tables = [fk[2] for fk in fks]
    assert "Department" in referenced_tables, "Student table must reference Department via Foreign Key"

def test_faculty_course_1_to_many(db_conn):
    fks = get_foreign_keys(db_conn, "Course")
    referenced_tables = [fk[2] for fk in fks]
    assert "Faculty" in referenced_tables, "Course table must reference Faculty via Foreign Key"

def test_student_course_many_to_many(db_conn):
    fks = get_foreign_keys(db_conn, "Enrollment")
    referenced_tables = [fk[2] for fk in fks]
    assert "Student" in referenced_tables, "Enrollment table must reference Student"
    assert "Course" in referenced_tables, "Enrollment table must reference Course"
