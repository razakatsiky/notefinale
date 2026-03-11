MariaDB [note_finale]> select * from note;
+----+------+-------------+---------------+------------+
| id | note | candidat_id | correcteur_id | matiere_id |
+----+------+-------------+---------------+------------+
| 11 |   15 |           1 |             1 |          1 |
| 12 |   10 |           1 |             2 |          1 |
| 13 |   12 |           1 |             3 |          1 |
| 14 |    9 |           2 |             1 |          1 |
| 15 |    8 |           2 |             2 |          1 |
| 16 |   11 |           2 |             3 |          1 |
| 17 |   10 |           1 |             1 |          2 |
| 18 |   10 |           1 |             2 |          2 |
| 19 |   13 |           2 |             1 |          2 |
| 20 |   11 |           2 |             2 |          2 |
+----+------+-------------+---------------+------------+
10 rows in set (0.001 sec)


MariaDB [note_finale]> select * from parametre;
+----+------------+------------+--------------+---------------+
| id | difference | id_matiere | id_operateur | id_resolution |
+----+------------+------------+--------------+---------------+
|  5 |          7 |          1 |            1 |             2 |
|  6 |          7 |          1 |            4 |             3 |
|  7 |          2 |          2 |            2 |             1 |
|  8 |          2 |          2 |            3 |             2 |
+----+------------+------------+--------------+---------------+
4 rows in set (0.001 sec)


MariaDB [note_finale]> select * from operateur;
+----+-----------+
| id | operateur |
+----+-----------+
|  1 | <         |
|  2 | <=        |
|  3 | >         |
|  4 | >=        |
+----+-----------+
4 rows in set (0.000 sec)

MariaDB [note_finale]>


MariaDB [note_finale]> select * from resolution;
+----+---------+
| id | nom     |
+----+---------+
|  1 | Petit   |
|  2 | Grand   |
|  3 | Moyenne |
+----+---------+
3 rows in set (0.001 sec)

MariaDB [note_finale]>


MariaDB [note_finale]> select * from candidat;
+----+-----------+
| id | nom       |
+----+-----------+
|  1 | Candidat1 |
|  2 | Candidat2 |
+----+-----------+
2 rows in set (0.063 sec)

MariaDB [note_finale]> select * from matiere;
+----+------+
| id | nom  |
+----+------+
|  1 | JAVA |
|  2 | PHP  |
+----+------+
2 rows in set (0.010 sec)

MariaDB [note_finale]>

MariaDB [note_finale]> select * from correcteur;
+----+-------------+
| id | nom         |
+----+-------------+
|  1 | Correcteur1 |
|  2 | Correcteur2 |
|  3 | Correcteur3 |
+----+-------------+
3 rows in set (0.006 sec)

MariaDB [note_finale]>