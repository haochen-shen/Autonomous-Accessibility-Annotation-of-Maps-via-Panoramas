# Autonomous-Accessibility-Annotation-of-Maps-via-Panoramas

This project serves as Shen Haochen's MSc final year project at Imperial College London for the 2022 academic year.

## System Design

![This is an image][object detection overview](https://user-images.githubusercontent.com/99172459/187585232-d4669342-3673-4af1-a6fc-020b5449677b.jpg)
t.svg)
![This is an image][map application overview](https://user-images.githubusercontent.com/99172459/187585278-3470f96b-a06b-42aa-a770-2ebff4ddc13b.jpg)

## User Guide

- **Object Detection Model** folder contains _YOLOv5 train model.ipynb_ and _YOLOv5 load model.ipynb_ for different size of images. It will be shown how the project trains the YOLOv5 model and how it is applied to object detection through detailed code scripts.

- **Panorama Dataset** and Panorama Dataset extra folders contain panoramic images of Imperial College London and its environs. These images are used to train the model and perform actual step and ramp detection tasks.

- **Test Dataset** folder contains panoramic images of British Museum and its surrounding areas. These images are utilised to evaluate the robustness of the trained YOLOv5 model in various environments.

- **YOLOv5 Testing and Results** folder contains the results and performance of models trained on varying sized image datasets. _best.pt_ saves the optimal weights for the model during training and can be loaded to detect steps and ramps. _results.png_ shows the model's loss and metric curves and it is used to evaluate the performance of the model. **test set image** folder includes examples of the model detecting panorama objects. _.geojson_ includes information regarding the accessibility location obtained by coordinate transformation.

- _Data processing.ipynb_ contains all methods for obtaining valid data. This includes extracting the image's metadata, converting the coordinates, calculating latitude and longitude, and converting the file format.

- **iOS Mapp Application** folder contains all Xcode files related to the development of iOS Map App. _routeselectionviewcontroller.swift_ and _directionviewcontroller.swift_ implement the map annotation and navigation functions, respectively. In addition, the UI design is primarily included in _.xib_ files.
    
