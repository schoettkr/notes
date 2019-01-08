#include <iostream>

using namespace std;

struct fliese {
  float x;
  float y;
};


void printMatrix(fliese* array, int i, int j) {
  for (int iIndex = 0; iIndex < i; iIndex++) {
    for (int jIndex = 0; jIndex < j; jIndex++) {
      if (array[jIndex + iIndex*j].x) // only print existing slabs
        cout << '\t' << array[jIndex + iIndex*j].x << '\t' << array[jIndex + iIndex*j].y << '\t' << " |";
    }
    cout << endl;
  }
}


int main() {
  float roomHeight, roomWidth, slabHeight, slabWidth;

  cout << "Bitte geben Sie die Raumbreite(X) in Zentimeter mit maximal 2 Dezimalstellen ein: ";
  cin >> roomWidth;
  cout << "Bitte geben Sie die Raumlänge(Y) in Zentimeter mit maximal 2 Dezimalstellen ein: ";
  cin >> roomHeight;


  cout << "Bitte geben Sie die Fliesenbreite(X) in Zentimeter mit maximal 2 Dezimalstellen ein: ";
  cin >> slabWidth;
  cout << "Bitte geben Sie die Fliesenlänge(Y) in Zentimeter mit maximal 2 Dezimalstellen ein: ";
  cin >> slabHeight;

  // #Todo: Null und Negative Werte abfangen evtl auch zu grosse/kleine Werte, sowie y > x
  // #Todo: Align eg 0.01 in print


  if (slabHeight == slabWidth) { // Fliesen sind quadratisch -> jede Reihe beginnt mit ganzer Fliese
    int slabsPerRow = 1 + int((roomWidth-slabWidth) / slabWidth + 0.9999); // required slabs per row (1 whole slab  + ceiled rest)
    int slabsPerCol = 1 + int((roomHeight-slabHeight) / slabHeight + 0.9999); // required slabs in col (y axis; 1 whole slab + ceiled rest)
    fliese room[slabsPerCol][slabsPerRow];
    // fill room matriix
    int roomHeightCopy = roomHeight;
    for (int i = 0; i < slabsPerCol; i++) {
      int roomWidthCopy = roomWidth; // deal with same width on every row
      for (int j = 0; j < slabsPerRow; j++) {
        if (j == 0 && i < slabsPerCol-1) { // all first slabs (per row) need to be whole
          room[i][j].x = 1;
          room[i][j].y = 1;
          roomWidthCopy -= slabWidth;
          continue;
        }

        if (slabWidth <= roomWidthCopy) { // put whole x-slab as long as possible
          room[i][j].x = 1;
          roomWidthCopy -= slabWidth;
        } else { // fill left x-space
          room[i][j].x = (int(roomWidthCopy/slabWidth*100))/100.0; // get rid of decimal places > 2
        }

        if (slabHeight < roomHeightCopy) { // put whole y-slab as long as possible
          room[i][j].y = 1;
        } else { // fill left y-space
          room[i][j].y = (int(roomHeightCopy/slabHeight*100))/100.0; // get rid of decimal places > 2
        }
      }
      roomHeightCopy -= slabHeight; // subtract height after whole row has been filled
    }
    printMatrix(*room, slabsPerCol, slabsPerRow);

  } else { // Fliesen sind nicht quadratisch x ist ein vielfaches von y zB y*2 -> jede 2te Reihe beginnt mit einer halben Fliese
    int slabsPerRow = 1 + int((roomWidth-0.5*slabWidth) / slabWidth + 0.9999); // max required slabs per row (1 whole slab  + ceiled rest)
    int slabsPerCol = int(roomHeight / slabHeight + 0.9999); // required slabs in col (y axis; ceiled)

    fliese room[slabsPerCol][slabsPerRow];
    int roomHeightCopy = roomHeight;
    for (int i = 0; i < slabsPerCol; i++) {
      float roomWidthCopy = (float (roomWidth)); // deal with same width on every row
      for (int j = 0; j < slabsPerRow; j++) {
        if (!(i % 2) && slabWidth <= roomWidthCopy) { // on odd row put whole x-slab as long as possible
          room[i][j].x = 1;
          roomWidthCopy -= slabWidth;
          
        } else if ((i % 2) && slabWidth <= roomWidthCopy) { // we are in row beginning with 0.5 slab
          if (j == 0) { // first place/col -> put 0.5 slab
            room[i][j].x = 0.5;
            roomWidthCopy -= 0.5*slabWidth;
          } else {
            room[i][j].x = 1;
            roomWidthCopy -= slabWidth;
          }
        } else { // slab is wider than room -> fill left x-space
          room[i][j].x = (int(roomWidthCopy/slabWidth*100))/100.0; // get rid of decimal places > 2
          roomWidthCopy = 0;
        }

        if (room[i][j].x == 0) {
          room[i][j].y = 0;
        } else if (slabHeight < roomHeightCopy) { // put whole y-slab as long as possible
          room[i][j].y = 1;
        } else { // fill left y-space
          room[i][j].y = (int(roomHeightCopy/slabHeight*100))/100.0; // get rid of decimal places > 2
        }
      }
      roomHeightCopy -= slabHeight; // subtract height after whole row has been filled
    }
    printMatrix(*room, slabsPerCol, slabsPerRow);
  }

  int totalSlabsPerRow = int(float(roomWidth) / slabWidth + 0.9999); // ceil slabs per row
  float totalCols = int(float(roomHeight) / slabHeight + 0.9999); // ceil cols
  int totalSlabs = totalSlabsPerRow*totalCols;
  cout << "\tInsgesamt werden " << totalSlabs << " Fliesen benötigt." << endl;

  float slabPriceInCent = slabWidth * slabHeight;
  float bundlePrice = slabPriceInCent * 10 * 0.75;
  int wholeBundles = totalSlabs / 10;
  int rest = totalSlabs % 10;
  float totalPriceInCent = 0.0;
  if (rest >= 8) { // more efficient to buy another bundle and don't use all slabs
    totalPriceInCent = bundlePrice * (wholeBundles + 1);
  } else {
    totalPriceInCent = bundlePrice * wholeBundles + slabPriceInCent * rest;
  }

  float totalPriceInEur = totalPriceInCent / 100;

  cout << "\tDer günstigste Gesamtpreis beträgt " << totalPriceInEur << "€." << endl;

  return 0;
}
