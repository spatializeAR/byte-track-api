#pragma once


struct Rect
{
	float x;
	float y;
	float width;
	float height;
};

struct Object
{
    Rect rect;
    int label;
    float prob;
};

struct Track
{
    int id;
    int state;
    int label;

    // rect
    float x;
    float y;
    float width;
    float height;

    int start_frame;
    float score;
};

// C APIs 
extern "C" {
    /**
     * @brief Destroy ByteTrack
     */
    void byte_track_dispose();

    /**
     * @brief Initialize ByteTrack
     * @param frame_rate A frame rate of the input
     * @param track_buffer A buffer size of each track
     */ 
    void byte_track_init(const int frame_rate, const int track_buffer);

    /**
     * @brief Track the objects in the image
     * @param object An array of detected objects
     * @param num_object A count of objects
     * @param num_track A count of detected tracks
     * @return An array of estimated tracks
     */
    Track* byte_track_update(const Object* objects, const size_t num_object, int* num_track);
}
