#include <iostream>
#include "BYTETracker.h"

int main(int argc, char** argv) {
    BYTETracker tracker(30, 30);

    vector<Object> objects {
        { { 20, 10, 5, 10}, 2, 0.9 },
        { { 20, 10, 30, 10}, 2, 0.8 },
    };
    vector<STrack> tracks = tracker.update(objects);
    cout << "tracks: " << tracks.size() << endl;
    return 0;
}
