#include <iostream>
#include <fstream>
#include<string>
using namespace std;

void pure_software();
int write_image();

int rawPixel[322][242];

int main() {

    write_image();
    pure_software();

	system("pause");
	return 0;
}

// read pixel values from .txt file, then do 2D convolution and output the binary image in a .txt file
void pure_software() {
    int currentRow = 0;
    int currentCol = 0;

    int pixelValue[9] = { 0,0,0,0,0,0,0,0,0 };
    int rawPixelVal = 0;
    int gx = 0; // gradient x
    int gy = 0; // gradient y
    int g_sum = 0; // abs(gx) + abs(gy)

    const char* rdfilename = "../zermatt_mid.txt";
    const char* wrfilename = "../zermattRes.txt";
    ifstream infile;
    infile.open(rdfilename);
    ofstream outfile;
    outfile.open(wrfilename);


    for (int i = 0; i < 322; i++) {
        for (int j = 0; j < 242; j++) {
            infile >> rawPixel[i][j];
        }
    }


    for (int i = 0; i < 320; i++) {
        // calculate for a row
        // first read 9 pixels
        for (int pixel_count = 0; pixel_count < 9; pixel_count++) {
            rawPixelVal = rawPixel[currentRow][currentCol];
            pixelValue[pixel_count] = ((rawPixelVal & 255) + ((rawPixelVal & 65280) >> 8) + ((rawPixelVal & 16711680) >> 16)) / 3;
            if (pixel_count % 3 == 2) {
                currentCol++;
                currentRow -= 2;
            }
            else {
                currentRow++;
            }
        }

        // 1-239 pixel in one row
        for (int j = 0; j < 239; j++) {
            // calculate 2d convolution
            gx = -pixelValue[0] - 2 * pixelValue[1] - pixelValue[2] + pixelValue[6] + 2 * pixelValue[7] + pixelValue[8];
            gy = -pixelValue[0] - 2 * pixelValue[3] - pixelValue[6] + pixelValue[2] + 2 * pixelValue[5] + pixelValue[8];
            g_sum = abs(gx) + abs(gy);
            // write g_sum into a .txt file
            if (g_sum > 200) {
                outfile << 0 << endl;
            }
            else {
                outfile << 1 << endl;
            }
            

            // shift and read new pixels
            for (int jj = 0; jj < 3; jj++) {
                pixelValue[jj] = pixelValue[3 + jj];
                pixelValue[3 + jj] = pixelValue[6 + jj];
                //rawPixelVal = IORD_32DIRECT(HPS_0_BRIDGES_BASE, currentAddr);
                rawPixelVal = rawPixel[currentRow][currentCol];
                pixelValue[6 + jj] = ((rawPixelVal & 255) + ((rawPixelVal & 65280) >> 8) + ((rawPixelVal & 16711680) >> 16)) / 3;
                if (jj == 2) {
                    currentCol++;
                    currentRow -= 2;
                }
                else {
                    currentRow++;
                }
            }
        }

        // last pixel in one row
        gx = -pixelValue[0] - 2 * pixelValue[1] - pixelValue[2] + pixelValue[6] + 2 * pixelValue[7] + pixelValue[8];
        gy = -pixelValue[0] - 2 * pixelValue[3] - pixelValue[6] + pixelValue[2] + 2 * pixelValue[5] + pixelValue[8];
        g_sum = abs(gx) + abs(gy);

        if (g_sum > 200) {
            outfile << 0 << endl;
        }
        else {
            outfile << 1 << endl;
        }

    }

    infile.close();
    outfile.close();

}

// add zero-padding around the original image, read from a .txt file, and write back to a .txt file
int write_image() {

    const char* rdfilename = "../zermatt.txt";
    const char* wrfilename = "../zermatt_mid.txt";
    int buffer[3];
    int writedata;
    ofstream outfile;
    outfile.open(wrfilename);
    ifstream infile;
    infile.open(rdfilename);

    int offset = 0;
    // first row - zero padding
    for (int i = 0; i < 242; i++) {
        offset = i * 4;
        outfile << 0 << endl;
    }

    for (int i = 0; i < 240 * 320; i++) {

        // first column and last column - zero padding
        if (i % 240 == 0) {
            offset += 4;
            outfile << 0 << endl;
        }

        for (int j = 0; j < 3; j++) {
            infile >> buffer[j];
        }
        int pixel_r = buffer[0] & 255;
        int pixel_g = buffer[1] & 255;
        int pixel_b = buffer[2] & 255;
        writedata = 0;
        writedata = writedata | (pixel_r << 16) | (pixel_g << 8) | (pixel_b & 255);
        outfile << writedata << endl;
        offset += 4;

        if (i % 240 == 239) {
            offset += 4;
            outfile << 0 << endl;
        }

    }

    // last row - zero padding
    for (int i = 0; i < 242; i++) {
        offset += 4;
        outfile << 0 << endl;
    }

    outfile.close();
    infile.close();

    cout << "finish!" << endl;
    return 0;
}
