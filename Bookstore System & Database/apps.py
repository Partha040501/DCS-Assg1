from flask import Flask, request, jsonify, render_template, redirect, url_for, flash
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from flask_bcrypt import Bcrypt
import mysql.connector
from mysql.connector import Error
import os
import pickle

# Import the hash function from the hash file
from password_utils import hash_password, check_password

app = Flask(__name__, static_folder='static')
app.secret_key = os.urandom(24)

# MySQL database configuration
db_config = {
    'user': 'root',
    'password': 'password123',
    'host': '127.0.0.1',
    'database': 'bookstore'
}

login_manager = LoginManager()
login_manager.init_app(app)
bcrypt = Bcrypt(app)
login_manager.login_view = 'login'

def get_db_connection():
    conn = mysql.connector.connect(**db_config)
    return conn

class User(UserMixin):
    def __init__(self, id, username, email, password):
        self.id = id
        self.username = username
        self.email = email
        self.password = password

@login_manager.user_loader
def load_user(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
    user_data = cursor.fetchone()
    conn.close()
    if user_data:
        return User(id=user_data['id'], username=user_data['username'], email=user_data['email'], password=user_data['password'])
    return None

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        
        hashed_password = hash_password(password)

        conn = get_db_connection()
        cursor = conn.cursor()
        try:
            cursor.execute("INSERT INTO users (username, email, password) VALUES (%s, %s, %s)", (username, email, hashed_password))
            conn.commit()
            flash('Account created successfully!', 'success')
            return redirect(url_for('login'))
        except Error as e:
            flash('Error creating account: ' + str(e), 'danger')
        finally:
            conn.close()

    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
        user_data = cursor.fetchone()
        conn.close()

        if user_data and check_password(user_data['password'], password):
            user = User(id=user_data['id'], username=user_data['username'], email=user_data['email'], password=user_data['password'])
            login_user(user)
            flash('Login successful!', 'success')
            return redirect(url_for('index'))
        else:
            flash('Invalid username or password', 'danger')

    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash('You have been logged out.', 'info')
    return redirect(url_for('login'))

@app.route('/')
@login_required
def index():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT id, title, author, price, image, categories, original_price FROM books")
    books = cursor.fetchall()
    conn.close()
    return render_template('index.html', books=books)

@app.route('/book/<int:book_id>')
@login_required
def book_detail(book_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM books WHERE id = %s", (book_id,))
    book = cursor.fetchone()
    conn.close()
    return render_template('book_detail.html', book=book)

@app.route('/add_to_cart/<int:book_id>')
@login_required
def add_to_cart(book_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO cart (user_id, book_id) VALUES (%s, %s)", (current_user.id, book_id))
    conn.commit()
    conn.close()
    flash('Book added to cart', 'success')
    return redirect(url_for('index'))

@app.route('/cart')
@login_required
def cart():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT books.id, books.title, books.author, books.price
        FROM cart
        JOIN books ON cart.book_id = books.id
        WHERE cart.user_id = %s
    """, (current_user.id,))
    cart_items = cursor.fetchall()

    # Calculate total price
    total = sum(item['price'] for item in cart_items)

    conn.close()
    return render_template('cart.html', cart_items=cart_items, total=total)

@app.route('/remove_from_cart/<int:book_id>')
@login_required
def remove_from_cart(book_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM cart WHERE user_id = %s AND book_id = %s", (current_user.id, book_id))
    conn.commit()
    conn.close()
    flash('Book removed from cart', 'success')
    return redirect(url_for('cart'))

@app.route('/checkout')
@login_required
def checkout():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT SUM(books.price) AS total
        FROM cart
        JOIN books ON cart.book_id = books.id
        WHERE cart.user_id = %s
    """, (current_user.id,))
    total = cursor.fetchone()['total']

    if total is None:
        flash('Your cart is empty', 'danger')
        return redirect(url_for('cart'))

    cursor.execute("INSERT INTO orders (user_id, total) VALUES (%s, %s)", (current_user.id, total))
    order_id = cursor.lastrowid

    cursor.execute("""
        SELECT books.id, books.price
        FROM cart
        JOIN books ON cart.book_id = books.id
        WHERE cart.user_id = %s
    """, (current_user.id,))
    cart_items = cursor.fetchall()

    for item in cart_items:
        cursor.execute("INSERT INTO order_items (order_id, book_id, quantity, price) VALUES (%s, %s, %s, %s)",
                       (order_id, item['id'], 1, item['price']))

    cursor.execute("DELETE FROM cart WHERE user_id = %s", (current_user.id,))
    conn.commit()
    conn.close()
    flash('Order placed successfully', 'success')
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True)
