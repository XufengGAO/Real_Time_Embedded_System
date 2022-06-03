# Edge Detection via Sobel Algorithm

### Description
This project implements edge detection based on the Sobel operator. It reads an image from memory, does edge detection, and then displays the result binary image on a LCD screen.

Details in our design are demonstrated in our report.

### Project Structure

```
- edge detection
  - Cplusplus
    - main.cpp  % cpp implementing sobel operators
  - test_image  % test images for our demo
    - original  % original images in .jpg/.ppm/.txt format
    - results   % result binary images after edge detection
      - Cpp     % images computed in Cpp, used as comparison
      - LCD     % photos of displayed image on the LCD
      - python  % images computed in python notebook, used as comparison
  - Python
    - sobel_op.ipynb  % python notebook implementing sobel operators
  - VHDL        % Quartus project
- README.md
- report.pdf
```

### Reference
[1] Kanopoulos, N., Vasanthavada, N., & Baker, R. L. (1988). Design of an image edge detection filter using the Sobel operator. IEEE Journal of solid-state circuits, 23(2), 358-367.
