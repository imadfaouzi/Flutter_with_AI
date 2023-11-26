from flask import Flask, request, jsonify, send_from_directory, abort
import os
import uuid

# --------------

import tensorflow as tf
from tensorflow.keras.models import load_model
from PIL import Image
import numpy as np

def predict_image_class(image_path):
    # Load the model
    model = load_model('my_model.h5')

    # Load and preprocess the image
    img = Image.open(image_path)
    img = img.resize((224, 224))  # Adjust the size according to your model's input size
    img_array = tf.keras.preprocessing.image.img_to_array(img)
    img_array = tf.expand_dims(img_array, 0)  # Add batch dimension
    img_array /= 255.0  # Normalize pixel values to be between 0 and 1

    # Make predictions
    predictions = model.predict(img_array)

    # Interpret the predictions
    class_labels = ["Agriculture", "Sport"]
    predicted_class_index = np.argmax(predictions)
    predicted_class_label = class_labels[predicted_class_index]

    return predicted_class_label





# --------------
app = Flask(__name__)

# Define the upload folder
UPLOAD_FOLDER = './public/img/'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Create the upload folder if it doesn't exist
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

def generate_unique_filename():
    """Generate a unique filename using UUID."""
    return str(uuid.uuid4())

@app.route('/addimage', methods=['POST'])
def add_image():
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'}), 400

    image_file = request.files['image']

    if image_file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    if image_file:
        # Generate a unique filename
        new_filename = generate_unique_filename()
        # Get the file extension
        _, file_extension = os.path.splitext(image_file.filename)
        new_filename += file_extension
        # Save the file to the upload folder
        image_file.save(os.path.join(app.config['UPLOAD_FOLDER'], new_filename))
        result_Predected = predict_image_class("./public/img/"+new_filename)

        return jsonify({'filename': new_filename, 'result_Predected':result_Predected})
        



if __name__ == '__main__':
     app.run(host='0.0.0.0', port=5000)
