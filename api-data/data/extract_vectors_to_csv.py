import os

import io
from PIL import Image
import numpy as np

from keras.applications.xception import Xception
from keras.applications.xception import preprocess_input

def load_images(path, target_height=299, target_width=299):
    try:
        img = Image.open(path)
        
        width, height = img.size
        if width != target_width or height != target_height:
            img = img.resize((target_height, target_width), Image.ANTIALIAS)
        
        return np.array(img)
    except:
        return None

def predict_image(x, model):
    x = x.astype('float32')
    x = np.expand_dims(x, axis=0)
    x = preprocess_input(x)

    features = model.predict(x)
    features = features.flatten()
    return features

# init
src_dir = './train_photos'
datadir = './preview'

model = Xception(include_top=False)

with open('vectors.csv', 'w') as csv:
    for filename in os.listdir(src_dir):
        fullname = os.path.join(datadir,filename)
        im =load_images(fullname, 50, 50)
        
        #predict and insert to cassandra
        if im is not None:
            try:
                print(filename)
                vec = predict_image(im, model)
                csv.write('{},{}\n'.format(filename, ','.join([str(x) for x in vec])))
            except (KeyboardInterrupt, SystemExit):
                raise
            except:
                print('FAILED! {}'.format(filename))
                pass
