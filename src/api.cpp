#include <iostream>
#include <iterator>
#include <vector>
#include "BYTETracker.h"

struct Track
{
    int id;
    int state;

    float top;
    float left;
    float bottom;
    float right;

    int start_frame;
    float score;
};

static BYTETracker * _tracker = NULL;
static std::vector<Track> _tracks;

Track to_track(const STrack& strack)
{
    Track track {
        strack.track_id,
        strack.state,

        strack.tlbr[0],
        strack.tlbr[1],
        strack.tlbr[2],
        strack.tlbr[3],

        strack.start_frame,
        strack.score
    };
    return track;
}

extern "C" {
    /**
     * @brief Destroy ByteTrack
     */
    void byte_track_destroy() {
        if(_tracker) {
            delete _tracker;
            _tracker = NULL;
        }
    }

    /**
     * @brief Initialize ByteTrack
     * @param frame_rate A frame rate of the input
     * @param track_buffer A buffer size of each track
     */ 
    void byte_track_create(const int frame_rate, const int track_buffer) {
        byte_track_destroy();
        _tracker = new BYTETracker(frame_rate, track_buffer);
    }

    /**
     * @brief Track the objects in the image
     * @param object An array of detected objects
     * @param num_object A count of objects
     * @param num_track A count of detected tracks
     * @return An array of estimated tracks
     */
    const Track* byte_track_update(const Object* objects, const size_t num_object, int* num_track) {
        vector<Object> v_objects(objects, objects + num_object);

        vector<STrack> stracks = _tracker->update(v_objects);
        _tracks.clear();
        for(auto& strack : stracks) {
            _tracks.push_back(to_track(strack));
        }
        *num_track = _tracks.size();
        return _tracks.data();
    }
}

int main(int argc, char** argv) {
    byte_track_create(30, 30);

    const vector<Object> objects {
        { { 5, 10, 10, 10, }, 2, 0.9 },
        { { 30, 31, 5, 10, }, 2, 0.8 },
    };
    int num_track;
    const Track* tracks = byte_track_update(objects.data(), objects.size(), &num_track);
    
    cout << "tracks: " << num_track << endl;

    for(int i = 0; i < num_track; ++i) {
        const Track& track = tracks[i];
        cout << "state:" << track.state << " id:" << track.id 
            << " tlbr:" << track.top << ',' << track.left << ',' << track.bottom << ',' << track.left
            << endl;
    }

    byte_track_destroy();

    return 0;
}
