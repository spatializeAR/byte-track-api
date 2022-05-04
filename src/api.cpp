#include <iostream>
#include <iterator>
#include <vector>
#include "BYTETracker.h"

struct Track
{
    int id;
    int state;

    // rect
    float x;
    float y;
    float width;
    float height;

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

        strack.tlwh[0],
        strack.tlwh[1],
        strack.tlwh[2],
        strack.tlwh[3],

        strack.start_frame,
        strack.score
    };
    return track;
}

extern "C" {
    /**
     * @brief Destroy ByteTrack
     */
    void byte_track_dispose() {
        if(_tracker) {
            delete _tracker;
            _tracker = NULL;
        }
        _tracks.clear();
    }

    /**
     * @brief Initialize ByteTrack
     * @param frame_rate A frame rate of the input
     * @param track_buffer A buffer size of each track
     */ 
    void byte_track_init(const int frame_rate, const int track_buffer) {
        byte_track_dispose();
        _tracker = new BYTETracker(frame_rate, track_buffer);
    }

    /**
     * @brief Track the objects in the image
     * @param object An array of detected objects
     * @param num_object A count of objects
     * @param num_track A count of detected tracks
     * @return An array of estimated tracks
     */
    Track* byte_track_update(const Object* objects, const size_t num_object, int* num_track) {
        vector<Object> v_objects(objects, objects + num_object);

        vector<STrack> stracks = _tracker->update(v_objects);
        _tracks.clear();
        for(auto& strack : stracks) {
            _tracks.push_back(to_track(strack));
        }
        *num_track = (int)_tracks.size();
        return _tracks.data();
    }
}

int main(int argc, char** argv) {
    byte_track_init(30, 30);

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
            << " rect:" << track.x << ',' << track.y << ',' << track.width << ',' << track.height
            << endl;
    }

    byte_track_dispose();

    return 0;
}
