from flask import Flask, jsonify, request
from flask_mysqldb import MySQL
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Configure MySQL
app.config['MYSQL_USER'] = '_USER_'
app.config['MYSQL_PASSWORD'] = '_PASSWORD_'
app.config['MYSQL_HOST'] = '_HOST_'
app.config['MYSQL_DB'] = '_DBNAME_'

mysql = MySQL(app)

# Create a new person (C in CRUD)
@app.route('/people', methods=['POST'])
def create_person():
    data = request.json
    name = data['name']
    age = data['age']
    cell_phone = data['cell_phone']

    conn = mysql.connection
    cursor = conn.cursor()
    cursor.execute("INSERT INTO People (name, age, cell_phone) VALUES (%s, %s, %s)", (name, age, cell_phone))
    conn.commit()
    cursor.close()

    return jsonify({'message': 'Person added successfully!'}), 201

# Retrieve all people (R in CRUD)
@app.route('/people', methods=['GET'])
def get_people():
    conn = mysql.connection
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM People")
    rows = cursor.fetchall()

    people = []
    for row in rows:
        people.append({'id': row[0], 'name': row[1], 'age': row[2], 'cell_phone': row[3]})

    cursor.close()

    response = jsonify(people)
    response.headers.add('Access-Control-Allow-Origin', '*')

    return response

# Retrieve a single person by ID (R in CRUD)
@app.route('/people/<int:id>', methods=['GET'])
def get_person(id):
    conn = mysql.connection
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM People WHERE id = %s", (id,))
    row = cursor.fetchone()

    if row:
        person = {'id': row[0], 'name': row[1], 'age': row[2], 'cell_phone': row[3]}
        cursor.close()

        return jsonify(person)
    else:
        cursor.close()
        return jsonify({'message': 'Person not found'}), 404

# Update a person's details (U in CRUD)
@app.route('/people/<int:id>', methods=['PUT'])
def update_person(id):
    data = request.json
    name = data['name']
    age = data['age']
    cell_phone = data['cell_phone']

    conn = mysql.connection
    cursor = conn.cursor()
    cursor.execute("UPDATE People SET name = %s, age = %s, cell_phone = %s WHERE id = %s", (name, age, cell_phone, id))
    conn.commit()
    cursor.close()

    return jsonify({'message': 'Person updated successfully!'})

# Delete a person (D in CRUD)
@app.route('/people/<int:id>', methods=['DELETE'])
def delete_person(id):
    conn = mysql.connection
    cursor = conn.cursor()
    cursor.execute("DELETE FROM People WHERE id = %s", (id,))
    conn.commit()
    cursor.close()

    return jsonify({'message': 'Person deleted successfully!'})

# Run the application
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
