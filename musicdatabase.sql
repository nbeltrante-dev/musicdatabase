/* Nicoletta Beltrante */
/* Lab 03: Music (full) */

/* PROBLEM 1 BEGIN */
CREATE TABLE label(
    label_name VARCHAR(20) PRIMARY KEY,
    label_street VARCHAR(40),
    label_city VARCHAR(20),
    label_state VARCHAR(20),
    label_postcode VARCHAR(10),
    label_nation VARCHAR(10)
);

CREATE TABLE artist(
    artist_name VARCHAR(40) PRIMARY KEY
);

CREATE TABLE person(
    person_id INT PRIMARY KEY,
    person_first_name VARCHAR(20),
    person_last_name VARCHAR(20)
);

CREATE TABLE composition(
    composition_id INT PRIMARY KEY,
    composition_title VARCHAR(40),
    composition_year INT
);

CREATE TABLE album(
    album_id INT PRIMARY KEY,
    album_label_id VARCHAR(20),
    album_title VARCHAR(40),
    album_year INT,
    artist_name VARCHAR(40) REFERENCES artist(artist_name),
    label_name VARCHAR(20) REFERENCES label(label_name)
);

CREATE TABLE is_member_of(
    start_date DATE,
    end_date DATE,
    artist_name VARCHAR(40) REFERENCES artist(artist_name),
    person_id INT REFERENCES person(person_id),
    PRIMARY KEY (start_date, artist_name, person_id)
);

CREATE TABLE composes(
    composes_role VARCHAR(10),
    composes_order INT,
    composition_id INT REFERENCES composition(composition_id),
    person_id INT REFERENCES person(person_id),
    PRIMARY KEY (composes_role, composition_id, person_id)
);

CREATE TABLE recording(
    recording_id INT,
    recording_length FLOAT,
    recording_date VARCHAR(20),
    composition_id INT REFERENCES composition(composition_id),
    PRIMARY KEY (recording_id, composition_id)
);

CREATE TABLE track(
    track_num INT,
    album_id INT REFERENCES album(album_id),
    composition_id INT,
    recording_id INT,
    FOREIGN KEY (recording_id, composition_id) REFERENCES recording(recording_id, composition_id),
    PRIMARY KEY (track_num, album_id)
);

CREATE TABLE performs(
    performs_role VARCHAR(20),
    composition_id INT,
    person_id INT REFERENCES person(person_id),
    recording_id INT,
    FOREIGN KEY (recording_id, composition_id) REFERENCES recording(recording_id, composition_id),
    PRIMARY KEY(performs_role, composition_id, person_id, recording_id)
);
/* PROBLEM 1 END */

/* PROBLEM 2 BEGIN */
SELECT track_num, composition_title
FROM track NATURAL JOIN album NATURAL JOIN composition 
WHERE album_title = 'Giant Steps';
/* PROBLEM 2 END */

/* PROBLEM 3 BEGIN */
SELECT person_first_name, person_last_name, performs_role
FROM person NATURAL JOIN performs NATURAL JOIN recording NATURAL JOIN composition
WHERE recording_date = '1959-05-04' AND composition_title = 'Giant Steps';
/* PROBLEM 3 END */

/* PROBLEM 4 BEGIN */
SELECT DISTINCT person_first_name, person_last_name
FROM person
WHERE person_id IN (SELECT person_id
                    FROM composes)
AND person_id IN (SELECT person_id
                  FROM performs
                  WHERE performs_role = 'tenor sax');
/* PROBLEM 4 END */

/* PROBLEM 5 BEGIN */
SELECT composition_title, track_num, album_title
FROM composition NATURAL JOIN track NATURAL JOIN album
WHERE (composition_id, album_id) IN (SELECT composition_id, album_id
                           FROM track
                           GROUP BY composition_id, album_id
                           HAVING COUNT(*) > 1)
ORDER BY composition_title ASC, track_num ASC;
/* PROBLEM 5 END */

/* PROBLEM 6 BEGIN */
SELECT recording_id, recording_date
FROM recording
WHERE NOT EXISTS(SELECT *
                 FROM album 
                 WHERE NOT EXISTS (
                     SELECT *
                     FROM track
                     WHERE track. recording_id = recording.recording_id
                     AND track.album_id = album.album_id
                 )
);
/* PROBLEM 6 END */

/* PROBLEM 7 BEGIN */
SELECT recording_id, recording_date
FROM recording NATURAL JOIN track
GROUP BY recording_id, recording_date
HAVING COUNT(DISTINCT album_id) = (SELECT COUNT(*) 
                          FROM album);
/* PROBLEM 7 END */
