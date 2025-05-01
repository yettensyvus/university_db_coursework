-- insert_sample_data.sql
-- Inserts sample data into the University Student Management System database
 -- Academic Schema
-- Insert faculties

INSERT INTO academic.faculties (faculty_name)
VALUES ('FACULTATEA DE BIOLOGIE SI PEDOLOGIE'),
       ('FACULTATEA DE DREPT'),
       ('FACULTATEA DE CHIMIE ŞI TEHNOLOGIE CHIMICĂ'),
       ('FACULTATEA DE FIZICA SI INGINERIE'),
       ('FACULTATEA DE ISTORIE ŞI FILOSOFIE'),
       ('FACULTATEA DE JURNALISM ŞI ŞTIINŢE ALE COMUNICĂRII'),
       ('FACULTATEA DE LITERE'),
       ('FACULTATEA DE MATEMATICĂ ŞI INFORMATICĂ'),
       ('FACULTATEA PSIHOLOGIE, ŞTIINŢE ALE EDUCAŢIEI, SOCIOLOGIE ȘI ASISTENȚĂ SOCIALĂ'),
       ('FACULTATEA DE RELAŢII INTERNAŢIONALE, ŞTIINŢE POLITICE ŞI ADMINISTRATIVE'),
       ('FACULTATEA DE ŞTIINŢE ECONOMICE');

-- Insert departments
-- FACULTY 1: FACULTATEA DE BIOLOGIE SI PEDOLOGIE

INSERT INTO academic.departments (faculty_id, department_name)
VALUES (1, 'Departament Biologie şi Ecologie'),
       (1, 'Departament Geoștiințe și Silvicultură');

-- FACULTY 2: FACULTATEA DE DREPT

INSERT INTO academic.departments (faculty_id, department_name)
VALUES (2, 'Departament Drept Privat'),
       (2, 'Departament Drept Public'),
       (2, 'Departament Drept Penal'),
       (2, 'Departament Drept Procedural'),
       (2, 'Departament Drept Internaţional şi European');

-- FACULTY 3: FACULTATEA DE CHIMIE ŞI TEHNOLOGIE CHIMICĂ

INSERT INTO academic.departments (faculty_id, department_name)
VALUES (3, 'Departament Chimie'),
       (3, 'Departament Chimie Industrială şi Ecologică');

-- FACULTY 4: FACULTATEA DE FIZICA SI INGINERIE

INSERT INTO academic.departments (faculty_id, department_name)
VALUES (4, 'Departament Fizică Teoretică "Iu.Perlin"'),
       (4, 'Departament Fizică Aplicată şi Informatica');

-- FACULTY 5: FACULTATEA DE ISTORIE ŞI FILOSOFIE

INSERT INTO academic.departments (faculty_id, department_name)
VALUES (5, 'Departament Istoria Românilor, Universală şi Arheologie'),
       (5, 'Departament Filosofie şi Antropologie');

-- FACULTY 6: FACULTATEA DE JURNALISM ŞI ŞTIINŢE ALE COMUNICĂRII

INSERT INTO academic.departments (faculty_id, department_name)
VALUES (6, 'Departament Teoria și Practica Jurnalismului'),
       (6, 'Departament Comunicare și Teoria Informării');

-- FACULTY 7: FACULTATEA DE LITERE

INSERT INTO academic.departments (faculty_id, department_name)
VALUES (7, 'Departament Traducere, Interpretare și Lingvistică Aplicată'),
       (7, 'Departament Lingvistică Română și Știință Literară'),
       (7, 'Departament Filologie Romano-Germanică'),
       (7, 'Departament Literatură Universală și Comparată și Filologie Rusă');

-- FACULTY 8: FACULTATEA DE MATEMATICĂ ŞI INFORMATICĂ

INSERT INTO academic.departments (faculty_id, department_name)
VALUES (8, 'Departament Matematică'),
       (8, 'Departament Informatică');

-- FACULTY 9: FACULTATEA PSIHOLOGIE, ŞTIINŢE ALE EDUCAŢIEI, SOCIOLOGIE ȘI ASISTENȚĂ SOCIALĂ

INSERT INTO academic.departments (faculty_id, department_name)
VALUES (9, 'Departament Psihologie'),
       (9, 'Departament Ştiinţe ale Educaţiei'),
       (9, 'Departament Sociologie și Asistență Socială');

-- FACULTY 10: FACULTATEA DE RELAŢII INTERNAŢIONALE, ŞTIINŢE POLITICE ŞI ADMINISTRATIVE

INSERT INTO academic.departments (faculty_id, department_name)
VALUES (10, 'Departament Relaţii Internaţionale'),
       (10, 'Departament Ştiinţe Politice și Administrative');

-- FACULTY 11: FACULTATEA DE ŞTIINŢE ECONOMICE

INSERT INTO academic.departments (faculty_id, department_name)
VALUES (11, 'Departament Administrarea Afacerilor'),
       (11, 'Departament Finanțe și Bănci'),
       (11, 'Departament Contabilitate'),
       (11, 'Departament Informatică Economică');

-- Insert study programs
 -- Department 1: Departament Biologie şi Ecologie

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (1, 'Biologie (Științe ale Educației)', 'Licență', 3, 180, 'Română'),
       (1, 'Biologie (Științe Biologice)', 'Licență', 3, 180, 'Română'),
       (1, 'Biologie moleculară', 'Licență', 3, 180, 'Română'),
       (1, 'Ecologie și protecția mediului', 'Licență', 3, 180, 'Română'),
       (1, 'Științe biologice aplicate', 'Master', 2, 120, 'Română'),
       (1, 'Biologia moleculară', 'Master', 2, 120, 'Română');

-- Department 2: Departament Geoștiințe și Silvicultură

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (2, 'Silvicultură și grădini publice', 'Licență', 4, 240, 'Română'),
       (2, 'Geografie', 'Licență', 3, 180, 'Română'),
       (2, 'Arhitectură peisajeră', 'Licență', 4, 240, 'Română'),
       (2, 'Managementul mediului', 'Master', 2, 120, 'Română'),
       (2, 'Design de landşaft şi spaţii verzi', 'Master', 2, 120, 'Română');

-- Department 3: Departament Drept Privat

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (3, 'Drept civil', 'Master', 1.5, 90, 'Română'),
       (3, 'Drept fiscal și vamal', 'Master', 1.5, 90, 'Română'),
       (3, 'Drept fiscal și activitate vamală', 'Master', 2, 120, 'Română'),
       (3, 'Dreptul relațiilor de muncă și comerciale în afaceri', 'Master', 1.5, 90, 'Română');

-- Department 4: Departament Drept Public

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (4, 'Drept', 'Licență', 4, 240, 'Română'),
       (4, 'Drept', 'Licență', 4, 240, 'Rusă'),
       (4, 'Drept', 'Licență', 4, 240, 'Engleză'),
       (4, 'Drept', 'Licență', 4, 240, 'Franceză'),
       (4, 'Drepturile omului', 'Master', 1.5, 90, 'Română'),
       (4, 'Drept public și guvernare electronică', 'Master', 1.5, 90, 'Română'),
       (4, 'Drept public (funcționari publici)', 'Master', 1.5, 90, 'Română'),
       (4, 'Anticorupție (funcționari publici)', 'Master', 1.5, 90, 'Română'),
       (4, 'Drept public (FR, funcționari publici)', 'Master', 1.5, 90, 'Română'),
       (4, 'Anticorupție (FR, funcționari publici)', 'Master', 1.5, 90, 'Română');

-- Department 5: Departament Drept Penal

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (5, 'Drept penal', 'Master', 1.5, 90, 'Română'),
       (5, 'Proces penal și criminalistică', 'Master', 1.5, 90, 'Română'),
       (5, 'Științe penale aplicative', 'Master', 1.5, 90, 'Română');

-- Department 6: Departament Drept Procedural

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (6, 'Proceduri judiciare civile', 'Master', 1.5, 90, 'Română');

-- Department 7: Departament Drept Internaţional şi European

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (7, 'Drept internațional', 'Master', 1.5, 90, 'Română');

-- Department 8: Departament Chimie

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (8, 'Chimie (Științe ale Educației)', 'Licență', 3, 180, 'Română'),
       (8, 'Chimie (Științe Chimice)', 'Licență', 3, 180, 'Română'),
       (8, 'Chimie biofarmaceutică', 'Licență', 3, 180, 'Română'),
       (8, 'Materiale avansate în chimie și biofarmaceutică', 'Master', 2, 120, 'Română');

-- Department 9: Departament Chimie Industrială şi Ecologică

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (9, 'Tehnologie chimică industrială', 'Licență', 4, 240, 'Română'),
       (9, 'Tehnologia produselor cosmetice și medicinale', 'Licență', 4, 240, 'Română'),
       (9, 'Tehnologii moderne în industria cosmetică, farmaceutică și în protecția mediului', 'Master', 1.5, 90, 'Română');

-- Department 10: Departament Fizică Teoretică "Iu.Perlin"

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (10, 'Fizică (Științe ale Educației)', 'Licență', 3, 180, 'Română'),
       (10, 'Fizică (Științe fizice)', 'Licență', 3, 180, 'Română'),
       (10, 'Fizică', 'Master', 2, 120, 'Română');

-- Department 11: Departament Fizică Aplicată şi Informatica

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (11, 'Tehnologia informației', 'Licență', 4, 240, 'Română'),
       (11, 'Metrologie și instrumentație virtuală', 'Licență', 4, 240, 'Română'),
       (11, 'Tehnologii informaționale în modelare', 'Master', 2, 120, 'Română'),
       (11, 'Procedee și metode de măsurare în ingineria mediului', 'Master', 2, 120, 'Română');

-- Department 12: Departament Istoria Românilor, Universală şi Arheologie

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (12, 'Istorie și limba engleză', 'Licență', 4, 240, 'Română'),
       (12, 'Istorie (Științe ale Educației)', 'Licență', 3, 180, 'Română'),
       (12, 'Istorie (Științe Umaniste)', 'Licență', 3, 180, 'Română'),
       (12, 'Stat și societate din perspectivă istorică: forme de guvernare, securitate națională și relații internaționale', 'Master', 2, 120, 'Română'),
       (12, 'Managementul Patrimoniului Cultural', 'Master', 2, 120, 'Română'),
       (12, 'Istoria și cultura religiilor', 'Master', 2, 120, 'Română');

-- Department 13: Departament Filosofie şi Antropologie

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (13, 'Antropologie', 'Licență', 3, 180, 'Română'),
       (13, 'Filozofie', 'Licență', 3, 180, 'Română'),
       (13, 'Filosofie, antropologie și management cultural', 'Master', 2, 120, 'Română'),
       (13, 'Filosofii contemporane', 'Master', 2, 120, 'Română');

-- Department 14: Departament Teoria și Practica Jurnalismului

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (14, 'Comunicare și relații publice', 'Licență', 3, 180, 'Română'),
       (14, 'Jurnalism și procese mediatice', 'Licență', 3, 180, 'Română'),
       (14, 'Producție multimedia', 'Licență', 3, 180, 'Română'),
       (14, 'Producție video și media promoting', 'Master', 2, 120, 'Română');

-- Department 15: Departament Comunicare și Teoria Informării

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (15, 'Biblioteconomie și știința informării', 'Licență', 3, 180, 'Română'),
       (15, 'Relații publice și publicitate', 'Master', 2, 120, 'Română');

-- Department 16: Departament Traducere, Interpretare și Lingvistică Aplicată

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (16, 'Traducere și interpretare. Limba engleză şi franceză', 'Licență', 4, 240, 'Română'),
       (16, 'Traducere și interpretare. Limba engleză şi germană', 'Licență', 4, 240, 'Română'),
       (16, 'Traducere și interpretare. Limba franceză şi engleză', 'Licență', 4, 240, 'Română'),
       (16, 'Traducere și interpretare. Limba engleză și italiană', 'Licență', 4, 240, 'Română'),
       (16, 'Comunicare multilingvă, management intercultural şi limbaje de afaceri', 'Master', 2, 120, 'Română'),
       (16, 'Traducere și interpretare de conferințe', 'Master', 2, 120, 'Română');

-- Department 17: Departament Lingvistică Română și Știință Literară

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (17, 'Limba şi literatura română', 'Licență', 3, 180, 'Română'),
       (17, 'Limba şi literatura română şi engleză', 'Licență', 4, 240, 'Română'),
       (17, 'Limba şi literatura română şi franceză', 'Licență', 4, 240, 'Română'),
       (17, 'Studii de filologie română și strategii educaționale', 'Master', 2, 120, 'Română'),
       (17, 'Limbă, literatură și civilizație românească', 'Master', 2, 120, 'Română');

-- Department 18: Departament Filologie Romano-Germanică

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (18, 'Limba și literatura spaniolă şi engleză', 'Licență', 4, 240, 'Română'),
       (18, 'Limba și literatura franceză şi engleză', 'Licență', 4, 240, 'Română'),
       (18, 'Limba și literatura engleză și franceză', 'Licență', 4, 240, 'Română'),
       (18, 'Limba și literatura germană şi engleză', 'Licență', 4, 240, 'Română');

-- Department 19: Departament Literatură Universală și Comparată și Filologie Rusă

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (19, 'Limba şi literatura rusă şi engleză', 'Licență', 4, 240, 'Română'),
       (19, 'Limba și literatura rusă', 'Master', 2, 120, 'Română');

-- Department 20: Departament Matematică

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (20, 'Matematică', 'Licență', 3, 180, 'Română'),
       (20, 'Matematică (Științe ale Educației)', 'Licență', 3, 180, 'Română'),
       (20, 'Matematici aplicate', 'Licență', 3, 180, 'Română');

-- Department 21: Departament Informatică

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (21, 'Informatică (Tehnologii ale informației și comunicațiilor)', 'Licență', 3, 180, 'Română'),
       (21, 'Informatică (Științe ale Educației)', 'Licență', 3, 180, 'Română'),
       (21, 'Informatică aplicată', 'Licență', 3, 180, 'Română'),
       (21, 'Designul jocurilor', 'Licență', 3, 180, 'Română'),
       (21, 'Designul jocurilor', 'Licență', 3, 180, 'Engleză'),
       (21, 'Designul jocurilor', 'Licență', 3, 180, 'Rusă');

-- Department 22: Departament Psihologie

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (22, 'Psihologie', 'Licență', 3, 180, 'Română'),
       (22, 'Psihologie', 'Licență', 3, 180, 'Rusă'),
       (22, 'Psihologie', 'Licență', 3, 180, 'Engleză'),
       (22, 'Psihologie clinică', 'Master', 2, 120, 'Română'),
       (22, 'Psihologia muncii și organizațională', 'Master', 2, 120, 'Română'),
       (22, 'Psihologie judiciară', 'Master', 2, 120, 'Română');

-- Department 23: Departament Ştiinţe ale Educaţiei

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (23, 'Psihopedagogie', 'Licență', 3, 180, 'Română'),
       (23, 'Pedagogie în învățământul primar și limba engleză', 'Licență', 4, 240, 'Română'),
       (23, 'Pedagogie în învățământul primar și Psihopedagogie', 'Licență', 4, 240, 'Română'),
       (23, 'Educație civică', 'Licență', 3, 180, 'Română'),
       (23, 'Management educațional', 'Master', 2, 120, 'Română'),
       (23, 'Formarea formatorilor', 'Master', 2, 120, 'Română');

-- Department 24: Departament Sociologie și Asistență Socială

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (24, 'Sociologie', 'Licență', 3, 180, 'Română'),
       (24, 'Asistență socială', 'Licență', 3, 180, 'Română'),
       (24, 'Consiliere pentru probleme de familie', 'Master', 2, 120, 'Română'),
       (24, 'Managementul serviciilor sociale', 'Master', 2, 120, 'Română'),
       (24, 'Sondaje de opinie, marketing și publicitate', 'Master', 2, 120, 'Română');

-- Department 25: Departament Relaţii Internaţionale

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (25, 'Relații Internaționale', 'Licență', 3, 180, 'Română'),
       (25, 'Relații Internaționale', 'Licență', 3, 180, 'Engleză'),
       (25, 'Relații Internaționale', 'Licență', 3, 180, 'Franceză'),
       (25, 'Relații Internaționale', 'Licență', 3, 180, 'Rusă'),
       (25, 'Studii diplomatice', 'Master', 2, 120, 'Română'),
       (25, 'Studii europene', 'Master', 2, 120, 'Română'),
       (25, 'Relații Internaționale (master, frecvență redusă)', 'Master', 2, 120, 'Română'),
       (25, 'Relații Internaționale (master, frecvență)', 'Master', 2, 120, 'Română');

-- Department 26: Departament Ştiinţe Politice și Administrative

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (26, 'Politologie', 'Licență', 3, 180, 'Română'),
       (26, 'Administrație Publică', 'Licență', 3, 180, 'Română'),
       (26, 'Politici și servicii publice', 'Master', 2, 120, 'Română'),
       (26, 'Studii de Securitate Națională', 'Master', 2, 120, 'Română'),
       (26, 'Administrare Publică (master, frecvență redusă)', 'Master', 2, 120, 'Română'),
       (26, 'Administrare Publică (master, frecvență)', 'Master', 2, 120, 'Română'),
       (26, 'Management politic și electoral', 'Master', 2, 120, 'Română');

-- Department 27: Departament Administrarea Afacerilor

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (27, 'Business și administrare', 'Licență', 3, 180, 'Română'),
       (27, 'Business și administrare', 'Licență', 3, 180, 'Engleză'),
       (27, 'Business și administrare', 'Licență', 3, 180, 'Franceză'),
       (27, 'Business și administrare', 'Licență', 3, 180, 'Rusă'),
       (27, 'Marketing și logistică', 'Licență', 3, 180, 'Română'),
       (27, 'Marketing și logistică', 'Licență', 3, 180, 'Engleză'),
       (27, 'Marketing și logistică', 'Licență', 3, 180, 'Franceză'),
       (27, 'Marketing și logistică', 'Licență', 3, 180, 'Rusă'),
       (27, 'Servicii hoteliere, turism și agrement', 'Licență', 3, 180, 'Română'),
       (27, 'Servicii hoteliere, turism și agrement', 'Licență', 3, 180, 'Engleză'),
       (27, 'Servicii hoteliere, turism și agrement', 'Licență', 3, 180, 'Franceză'),
       (27, 'Servicii hoteliere, turism și agrement', 'Licență', 3, 180, 'Rusă'),
       (27, 'Administrarea afacerilor', 'Master', 2, 120, 'Română'),
       (27, 'Managementul resurselor umane', 'Master', 2, 120, 'Română'),
       (27, 'Studii în marketing', 'Master', 2, 120, 'Română'),
       (27, 'Management şi marketing hotelier şi turism', 'Master', 2, 120, 'Română'),
       (27, 'Management (inclusiv pentru funcționari publici)', 'Master', 2, 120, 'Română'),
       (27, 'Management (cu frecvență redusă, inclusiv pentru funcționari publici)', 'Master', 2, 120, 'Română');

-- Department 28: Departament Finanțe și Bănci

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (28, 'Finanțe și bănci', 'Licență', 3, 180, 'Română'),
       (28, 'Finanțe și bănci', 'Licență', 3, 180, 'Engleză'),
       (28, 'Finanțe și bănci', 'Licență', 3, 180, 'Franceză'),
       (28, 'Finanțe și bănci', 'Licență', 3, 180, 'Rusă'),
       (28, 'Audit şi expertiză financiară', 'Master', 2, 120, 'Română'),
       (28, 'Administrare bancară', 'Master', 2, 120, 'Română'),
       (28, 'Finanţe publice şi fiscalitate', 'Master', 2, 120, 'Română'),
       (28, 'Gestiunea finanţelor şi contabilitatea în afaceri', 'Master', 2, 120, 'Română');

-- Department 29: Departament Contabilitate

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (29, 'Contabilitate', 'Licență', 3, 180, 'Română'),
       (29, 'Contabilitate', 'Licență', 3, 180, 'Franceză'),
       (29, 'Contabilitate', 'Licență', 3, 180, 'Rusă'),
       (29, 'Contabilitatea întreprinderii', 'Master', 2, 120, 'Română');

-- Department 30: Departament Informatică Economică

INSERT INTO academic.study_programs (department_id, program_name, degree_level, duration_years, credits_required, LANGUAGE)
VALUES (30, 'Baze de date şi tehnici actuariale', 'Master', 2, 120, 'Română');

-- Insert courses
-- Insert courses for academic departments
-- Department 1: Departament Biologie şi Ecologie

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (1, 'BIO101', 'Biologie celulară', 6, TRUE),
       (1, 'BIO102', 'Botanică generală', 5, TRUE),
       (1, 'BIO103', 'Zoologie generală', 5, TRUE),
       (1, 'BIO104', 'Ecologie generală', 4, TRUE),
       (1, 'BIO105', 'Microbiologie', 6, TRUE),
       (1, 'BIO201', 'Genetică moleculară', 6, TRUE),
       (1, 'BIO202', 'Fiziologie vegetală', 5, TRUE),
       (1, 'BIO203', 'Fiziologie animală', 5, TRUE),
       (1, 'BIO204', 'Biochimie', 6, TRUE),
       (1, 'BIO205', 'Biologie evolutivă', 4, TRUE);

-- Department 2: Departament Geoștiințe și Silvicultură

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (2, 'GEO101', 'Geografie fizică', 5, TRUE),
       (2, 'GEO102', 'Geomorfologie', 5, TRUE),
       (2, 'GEO103', 'Pedologie', 4, TRUE),
       (2, 'GEO104', 'Silvicultură generală', 6, TRUE),
       (2, 'GEO105', 'Sisteme Informaționale Geografice', 5, TRUE),
       (2, 'GEO201', 'Amenajarea teritoriului', 5, TRUE),
       (2, 'GEO202', 'Peisagistică', 5, TRUE),
       (2, 'GEO203', 'Dendrologie', 6, TRUE),
       (2, 'GEO204', 'Hidrologie', 4, TRUE),
       (2, 'GEO205', 'Managementul resurselor forestiere', 6, TRUE);

-- Department 3: Departament Drept Privat

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (3, 'DPR101', 'Drept civil: partea generală', 6, TRUE),
       (3, 'DPR102', 'Dreptul obligațiilor', 6, TRUE),
       (3, 'DPR103', 'Dreptul proprietății', 5, TRUE),
       (3, 'DPR104', 'Dreptul familiei', 5, TRUE),
       (3, 'DPR105', 'Drept succesoral', 5, TRUE),
       (3, 'DPR201', 'Drept comercial', 6, TRUE),
       (3, 'DPR202', 'Dreptul muncii', 5, TRUE),
       (3, 'DPR203', 'Dreptul proprietății intelectuale', 5, TRUE),
       (3, 'DPR204', 'Drept bancar', 5, TRUE),
       (3, 'DPR205', 'Drept fiscal', 6, TRUE);

-- Department 4: Departament Drept Public

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (4, 'DPU101', 'Drept constituțional', 6, TRUE),
       (4, 'DPU102', 'Drept administrativ', 6, TRUE),
       (4, 'DPU103', 'Drepturile omului', 5, TRUE),
       (4, 'DPU104', 'Drept electoral', 4, TRUE),
       (4, 'DPU105', 'Instituții administrative', 5, TRUE),
       (4, 'DPU201', 'Contencios administrativ', 5, TRUE),
       (4, 'DPU202', 'Drept parlamentar', 4, TRUE),
       (4, 'DPU203', 'Dreptul mediului', 5, TRUE),
       (4, 'DPU204', 'Drept funciaresc', 5, TRUE),
       (4, 'DPU205', 'Administrație publică', 6, TRUE);

-- Department 5: Departament Drept Penal

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (5, 'DPN101', 'Drept penal: partea generală', 6, TRUE),
       (5, 'DPN102', 'Drept penal: partea specială', 6, TRUE),
       (5, 'DPN103', 'Criminologie', 5, TRUE),
       (5, 'DPN104', 'Drept execuțional penal', 5, TRUE),
       (5, 'DPN105', 'Calificarea infracțiunilor', 5, TRUE),
       (5, 'DPN201', 'Criminalistică', 6, TRUE),
       (5, 'DPN202', 'Drept penal comparat', 5, TRUE),
       (5, 'DPN203', 'Justiție juvenilă', 4, TRUE),
       (5, 'DPN204', 'Medicină legală', 5, TRUE),
       (5, 'DPN205', 'Victimologie', 4, TRUE);

-- Department 6: Departament Drept Procedural

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (6, 'DPR101', 'Drept procesual civil', 6, TRUE),
       (6, 'DPR102', 'Drept procesual penal', 6, TRUE),
       (6, 'DPR103', 'Organizarea judecătorească', 4, TRUE),
       (6, 'DPR104', 'Executare silită', 5, TRUE),
       (6, 'DPR105', 'Arbitraj', 4, TRUE),
       (6, 'DPR201', 'Proceduri speciale civile', 5, TRUE),
       (6, 'DPR202', 'Proceduri speciale penale', 5, TRUE),
       (6, 'DPR203', 'Tehnici de argumentare juridică', 4, TRUE),
       (6, 'DPR204', 'Practică judiciară', 6, TRUE),
       (6, 'DPR205', 'Mediere și conciliere', 4, TRUE);

-- Department 7: Departament Drept Internaţional şi European

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (7, 'DIE101', 'Drept internațional public', 6, TRUE),
       (7, 'DIE102', 'Drept internațional privat', 6, TRUE),
       (7, 'DIE103', 'Dreptul Uniunii Europene', 6, TRUE),
       (7, 'DIE104', 'Drept diplomatic și consular', 5, TRUE),
       (7, 'DIE105', 'Organizații internaționale', 5, TRUE),
       (7, 'DIE201', 'Drept comunitar', 5, TRUE),
       (7, 'DIE202', 'Drept comercial internațional', 5, TRUE),
       (7, 'DIE203', 'Protecția internațională a drepturilor omului', 5, TRUE),
       (7, 'DIE204', 'Drept internațional umanitar', 5, TRUE),
       (7, 'DIE205', 'Contencios european', 5, TRUE);

-- Department 8: Departament Chimie

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (8, 'CHM101', 'Chimie generală', 6, TRUE),
       (8, 'CHM102', 'Chimie anorganică', 6, TRUE),
       (8, 'CHM103', 'Chimie organică', 6, TRUE),
       (8, 'CHM104', 'Chimie analitică', 5, TRUE),
       (8, 'CHM105', 'Biochimie', 5, TRUE),
       (8, 'CHM201', 'Chimie fizică', 6, TRUE),
       (8, 'CHM202', 'Chimie cuantică și spectroscopie', 5, TRUE),
       (8, 'CHM203', 'Chimie coordinativă', 5, TRUE),
       (8, 'CHM204', 'Chimia compușilor naturali', 5, TRUE),
       (8, 'CHM205', 'Metode fizico-chimice de analiză', 6, TRUE);

-- Department 9: Departament Chimie Industrială şi Ecologică

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (9, 'CIE101', 'Procese chimice industriale', 6, TRUE),
       (9, 'CIE102', 'Tehnologia apei', 5, TRUE),
       (9, 'CIE103', 'Chimia mediului', 5, TRUE),
       (9, 'CIE104', 'Tehnologii cosmetice', 5, TRUE),
       (9, 'CIE105', 'Tehnologii farmaceutice', 6, TRUE),
       (9, 'CIE201', 'Controlul poluării', 5, TRUE),
       (9, 'CIE202', 'Chimie ecologică', 5, TRUE),
       (9, 'CIE203', 'Polimeri și materiale composite', 6, TRUE),
       (9, 'CIE204', 'Nanomateriale', 5, TRUE),
       (9, 'CIE205', 'Tehnologii de mediu', 5, TRUE);

-- Department 10: Departament Fizică Teoretică "Iu.Perlin"

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (10, 'FIZ101', 'Mecanică', 6, TRUE),
       (10, 'FIZ102', 'Electrodinamică', 6, TRUE),
       (10, 'FIZ103', 'Optică', 5, TRUE),
       (10, 'FIZ104', 'Termodinamică și fizică statistică', 6, TRUE),
       (10, 'FIZ105', 'Fizică cuantică', 6, TRUE),
       (10, 'FIZ201', 'Fizica atomului și nucleului', 5, TRUE),
       (10, 'FIZ202', 'Teoria relativității', 5, TRUE),
       (10, 'FIZ203', 'Fizica corpului solid', 5, TRUE),
       (10, 'FIZ204', 'Fizica particulelor elementare', 5, TRUE),
       (10, 'FIZ205', 'Astrofizică', 5, TRUE);

-- Department 11: Departament Fizică Aplicată şi Informatica

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (11, 'FAI101', 'Fizica semiconductorilor', 5, TRUE),
       (11, 'FAI102', 'Electronica fizică', 5, TRUE),
       (11, 'FAI103', 'Programarea calculatoarelor', 6, TRUE),
       (11, 'FAI104', 'Metrologie', 5, TRUE),
       (11, 'FAI105', 'Metodele fizice de cercetare', 5, TRUE),
       (11, 'FAI201', 'Fizica dispozitivelor electronice', 5, TRUE),
       (11, 'FAI202', 'Măsurări electronice', 5, TRUE),
       (11, 'FAI203', 'Tehnologii informaționale', 6, TRUE),
       (11, 'FAI204', 'Modelarea proceselor fizice', 5, TRUE),
       (11, 'FAI205', 'Instrumentație virtuală', 6, TRUE);

-- Department 12: Departament Istoria Românilor, Universală şi Arheologie

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (12, 'IST101', 'Preistorie și antichitate', 5, TRUE),
       (12, 'IST102', 'Istoria medievală', 5, TRUE),
       (12, 'IST103', 'Istoria modernă', 5, TRUE),
       (12, 'IST104', 'Istoria contemporană', 5, TRUE),
       (12, 'IST105', 'Arheologie', 6, TRUE),
       (12, 'IST201', 'Istoria românilor', 6, TRUE),
       (12, 'IST202', 'Istorie universală', 5, TRUE),
       (12, 'IST203', 'Muzeologie', 4, TRUE),
       (12, 'IST204', 'Patrimoniu cultural', 5, TRUE),
       (12, 'IST205', 'Istoria artei', 4, TRUE);

-- Department 13: Departament Filosofie şi Antropologie

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (13, 'FIL101', 'Filosofie antică', 5, TRUE),
       (13, 'FIL102', 'Filosofie medievală', 5, TRUE),
       (13, 'FIL103', 'Filosofie modernă', 5, TRUE),
       (13, 'FIL104', 'Filosofie contemporană', 5, TRUE),
       (13, 'FIL105', 'Antropologie culturală', 5, TRUE),
       (13, 'FIL201', 'Etică', 4, TRUE),
       (13, 'FIL202', 'Estetică', 4, TRUE),
       (13, 'FIL203', 'Filosofia științei', 5, TRUE),
       (13, 'FIL204', 'Logică', 5, TRUE),
       (13, 'FIL205', 'Metafizică', 5, TRUE);

-- Department 14: Departament Teoria și Practica Jurnalismului

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (14, 'JUR101', 'Introducere în jurnalism', 5, TRUE),
       (14, 'JUR102', 'Genuri jurnalistice', 5, TRUE),
       (14, 'JUR103', 'Tehnici de reportaj', 6, TRUE),
       (14, 'JUR104', 'Fotojurnalism', 5, TRUE),
       (14, 'JUR105', 'Redactare și editare', 5, TRUE),
       (14, 'JUR201', 'Jurnalismul de investigație', 6, TRUE),
       (14, 'JUR202', 'Jurnalism digital', 5, TRUE),
       (14, 'JUR203', 'Producție video', 6, TRUE),
       (14, 'JUR204', 'Etica și deontologia jurnalismului', 4, TRUE),
       (14, 'JUR205', 'Management media', 5, TRUE);

-- Department 15: Departament Comunicare și Teoria Informării

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (15, 'COM101', 'Teoria comunicării', 5, TRUE),
       (15, 'COM102', 'Comunicare publică', 5, TRUE),
       (15, 'COM103', 'Relații publice', 5, TRUE),
       (15, 'COM104', 'Comunicare organizațională', 5, TRUE),
       (15, 'COM105', 'Publicitate', 5, TRUE),
       (15, 'COM201', 'Comunicare strategică', 5, TRUE),
       (15, 'COM202', 'Semiotică și analiza discursului', 5, TRUE),
       (15, 'COM203', 'Managementul informației', 5, TRUE),
       (15, 'COM204', 'Comunicare politică', 5, TRUE),
       (15, 'COM205', 'Comunicare interculturală', 5, TRUE);

-- Department 16: Departament Traducere, Interpretare și Lingvistică Aplicată

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (16, 'TRA101', 'Teoria traducerii', 5, TRUE),
       (16, 'TRA102', 'Traducere generală EN-RO', 6, TRUE),
       (16, 'TRA103', 'Traducere generală FR-RO', 6, TRUE),
       (16, 'TRA104', 'Interpretare consecutivă', 6, TRUE),
       (16, 'TRA105', 'Terminologie specializată', 5, TRUE),
       (16, 'TRA201', 'Traducere specializată juridică', 5, TRUE),
       (16, 'TRA202', 'Traducere specializată economică', 5, TRUE),
       (16, 'TRA203', 'Interpretare simultană', 6, TRUE),
       (16, 'TRA204', 'Tehnologii în traducere', 5, TRUE),
       (16, 'TRA205', 'Lingvistică contrastivă', 5, TRUE);

-- Department 17: Departament Lingvistică Română și Știință Literară

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (17, 'LIN101', 'Lingvistică generală', 5, TRUE),
       (17, 'LIN102', 'Fonetică și fonologie', 5, TRUE),
       (17, 'LIN103', 'Morfologie', 5, TRUE),
       (17, 'LIN104', 'Sintaxă', 5, TRUE),
       (17, 'LIN105', 'Istoria limbii române', 5, TRUE),
       (17, 'LIN201', 'Teoria literaturii', 5, TRUE),
       (17, 'LIN202', 'Literatura română veche', 5, TRUE),
       (17, 'LIN203', 'Literatura română modernă', 5, TRUE),
       (17, 'LIN204', 'Literatura română contemporană', 5, TRUE),
       (17, 'LIN205', 'Stilistică și poetică', 5, TRUE);

-- Department 18: Departament Filologie Romano-Germanică

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (18, 'FRG101', 'Lingvistică engleză', 5, TRUE),
       (18, 'FRG102', 'Lingvistică franceză', 5, TRUE),
       (18, 'FRG103', 'Lingvistică germană', 5, TRUE),
       (18, 'FRG104', 'Lingvistică spaniolă', 5, TRUE),
       (18, 'FRG105', 'Lingvistică italiană', 5, TRUE),
       (18, 'FRG201', 'Literatura engleză', 5, TRUE),
       (18, 'FRG202', 'Literatura franceză', 5, TRUE),
       (18, 'FRG203', 'Literatura germană', 5, TRUE),
       (18, 'FRG204', 'Literatura spaniolă', 5, TRUE),
       (18, 'FRG205', 'Literatura italiană', 5, TRUE);

-- Department 19: Departament Literatură Universală și Comparată și Filologie Rusă

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (19, 'LUC101', 'Literatură universală antică', 5, TRUE),
       (19, 'LUC102', 'Literatură universală medievală', 5, TRUE),
       (19, 'LUC103', 'Literatură universală modernă', 5, TRUE),
       (19, 'LUC104', 'Literatură universală contemporană', 5, TRUE),
       (19, 'LUC105', 'Literatură comparată', 5, TRUE),
       (19, 'LUC201', 'Lingvistică rusă', 5, TRUE),
       (19, 'LUC202', 'Literatura rusă clasică', 5, TRUE),
       (19, 'LUC203', 'Literatura rusă modernă', 5, TRUE),
       (19, 'LUC204', 'Literatura rusă contemporană', 5, TRUE),
       (19, 'LUC205', 'Cultura și civilizația rusă', 5, TRUE);

-- Department 20: Departament Matematică

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (20, 'MAT101', 'Analiză matematică I', 6, TRUE),
       (20, 'MAT102', 'Algebră liniară și geometrie analitică', 6, TRUE),
       (20, 'MAT103', 'Teoria probabilităților', 5, TRUE),
       (20, 'MAT104', 'Ecuații diferențiale', 6, TRUE),
       (20, 'MAT105', 'Analiză matematică II', 6, TRUE),
       (20, 'MAT201', 'Analiză funcțională', 5, TRUE),
       (20, 'MAT202', 'Algebră abstractă', 5, TRUE),
       (20, 'MAT203', 'Geometrie diferențială', 5, TRUE),
       (20, 'MAT204', 'Topologie', 5, TRUE),
       (20, 'MAT205', 'Teoria numerelor', 5, TRUE);

-- Department 21: Departament Informatică

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (21, 'INF101', 'Programare orientată pe obiecte', 6, TRUE),
       (21, 'INF102', 'Algoritmi și structuri de date', 6, TRUE),
       (21, 'INF103', 'Baze de date', 6, TRUE),
       (21, 'INF104', 'Rețele de calculatoare', 5, TRUE),
       (21, 'INF105', 'Sisteme de operare', 5, TRUE),
       (21, 'INF201', 'Inteligență artificială', 6, TRUE),
       (21, 'INF202', 'Ingineria softului', 5, TRUE),
       (21, 'INF203', 'Grafică pe calculator', 5, TRUE),
       (21, 'INF204', 'Programare web', 6, TRUE),
       (21, 'INF205', 'Securitate informatică', 5, TRUE);

-- Department 22: Departament Psihologie

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (22, 'PSI101', 'Psihologie generală', 6, TRUE),
       (22, 'PSI102', 'Psihologia dezvoltării', 5, TRUE),
       (22, 'PSI103', 'Psihologie socială', 5, TRUE),
       (22, 'PSI104', 'Psihologie clinică', 6, TRUE),
       (22, 'PSI105', 'Neuropsihologie', 5, TRUE),
       (22, 'PSI201', 'Psihodiagnostic', 6, TRUE),
       (22, 'PSI202', 'Psihoterapie', 6, TRUE),
       (22, 'PSI203', 'Psihologia muncii și organizațională', 5, TRUE),
       (22, 'PSI204', 'Psihologia cogniției', 5, TRUE),
       (22, 'PSI205', 'Psihologia personalității', 5, TRUE);

-- Department 23: Departament Ştiinţe ale Educaţiei

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (23, 'EDU101', 'Pedagogie generală', 6, TRUE),
       (23, 'EDU102', 'Teoria educației', 5, TRUE),
       (23, 'EDU103', 'Psihopedagogie', 5, TRUE),
       (23, 'EDU104', 'Didactică', 6, TRUE),
       (23, 'EDU105', 'Teoria și metodologia curriculum-ului', 5, TRUE),
       (23, 'EDU201', 'Teoria și metodologia evaluării', 5, TRUE),
       (23, 'EDU202', 'Management educațional', 5, TRUE),
       (23, 'EDU203', 'Educație incluzivă', 5, TRUE),
       (23, 'EDU204', 'Psihopedagogia comportamentului deviant', 5, TRUE),
       (23, 'EDU205', 'Consiliere educațională', 5, TRUE);

-- Department 24: Departament Sociologie și Asistență Socială

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (24, 'SOC101', 'Sociologie generală', 6, TRUE),
       (24, 'SOC102', 'Metodologia cercetării sociologice', 6, TRUE),
       (24, 'SOC103', 'Statistică aplicată în științele sociale', 5, TRUE),
       (24, 'SOC104', 'Asistență socială', 5, TRUE),
       (24, 'SOC105', 'Politici sociale', 5, TRUE),
       (24, 'SOC201', 'Sociologia familiei', 5, TRUE),
       (24, 'SOC202', 'Sociologia organizațiilor', 5, TRUE),
       (24, 'SOC203', 'Asistența socială a familiei și copilului', 5, TRUE),
       (24, 'SOC204', 'Sociologie urbană și rurală', 5, TRUE),
       (24, 'SOC205', 'Proiectare și evaluare în asistența socială', 5, TRUE);

-- Department 25: Departament Relaţii Internaţionale

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (25, 'REL101', 'Teoria relațiilor internaționale', 6, TRUE),
       (25, 'REL102', 'Istorie diplomatică', 5, TRUE),
       (25, 'REL103', 'Organizații internaționale', 5, TRUE),
       (25, 'REL104', 'Politica externă comparată', 5, TRUE),
       (25, 'REL105', 'Securitate internațională', 5, TRUE),
       (25, 'REL201', 'Geopolitică', 5, TRUE),
       (25, 'REL202', 'Diplomație', 5, TRUE),
       (25, 'REL203', 'Instituții europene', 5, TRUE),
       (25, 'REL204', 'Negociere internațională', 5, TRUE),
       (25, 'REL205', 'Analiza conflictelor internaționale', 5, TRUE);

-- Department 26: Departament Ştiinţe Politice și Administrative

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (26, 'POL101', 'Teoria politică', 6, TRUE),
       (26, 'POL102', 'Sisteme politice comparate', 5, TRUE),
       (26, 'POL103', 'Administrație publică', 5, TRUE),
       (26, 'POL104', 'Politici publice', 5, TRUE),
       (26, 'POL105', 'Partide și sisteme de partide', 5, TRUE),
       (26, 'POL201', 'Analiză politică', 5, TRUE),
       (26, 'POL202', 'Administrație publică comparată', 5, TRUE),
       (26, 'POL203', 'Comunicare politică', 5, TRUE),
       (26, 'POL204', 'Management public', 5, TRUE),
       (26, 'POL205', 'Marketing politic', 5, TRUE);

-- Department 27: Departament Administrarea Afacerilor

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (27, 'MAN101', 'Bazele managementului', 6, TRUE),
       (27, 'MAN102', 'Marketing', 6, TRUE),
       (27, 'MAN103', 'Comportament organizațional', 5, TRUE),
       (27, 'MAN104', 'Managementul resurselor umane', 5, TRUE),
       (27, 'MAN105', 'Managementul calității', 5, TRUE),
       (27, 'MAN201', 'Managementul strategic', 5, TRUE),
       (27, 'MAN202', 'Managementul proiectelor', 5, TRUE),
       (27, 'MAN203', 'Analiza economico-financiară', 5, TRUE),
       (27, 'MAN204', 'Managementul inovării', 5, TRUE),
       (27, 'MAN205', 'Managementul serviciilor', 5, TRUE);

-- Department 28: Departament Finanțe și Bănci

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (28, 'FIN101', 'Finanțe publice', 6, TRUE),
       (28, 'FIN102', 'Monedă și credit', 5, TRUE),
       (28, 'FIN103', 'Piețe financiare', 5, TRUE),
       (28, 'FIN104', 'Fiscalitate', 5, TRUE),
       (28, 'FIN105', 'Asigurări și reasigurări', 5, TRUE),
       (28, 'FIN201', 'Gestiunea portofoliului', 5, TRUE),
       (28, 'FIN202', 'Operațiuni bancare', 5, TRUE),
       (28, 'FIN203', 'Finanțe corporative', 6, TRUE),
       (28, 'FIN204', 'Analiză financiară', 5, TRUE),
       (28, 'FIN205', 'Evaluarea întreprinderii', 5, TRUE);

-- Department 29: Departament Contabilitate

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (29, 'CON101', 'Bazele contabilității', 6, TRUE),
       (29, 'CON102', 'Contabilitate financiară', 6, TRUE),
       (29, 'CON103', 'Contabilitate de gestiune', 5, TRUE),
       (29, 'CON104', 'Audit financiar', 5, TRUE),
       (29, 'CON105', 'Control financiar', 5, TRUE),
       (29, 'CON201', 'Contabilitate aprofundată', 6, TRUE),
       (29, 'CON202', 'Standarde internaționale de raportare financiară', 6, TRUE),
       (29, 'CON203', 'Expertiză contabilă', 5, TRUE),
       (29, 'CON204', 'Contabilitate bancară', 5, TRUE),
       (29, 'CON205', 'Contabilitatea instituțiilor publice', 5, TRUE);

-- Department 30: Departament Informatică Economică

INSERT INTO academic.courses (department_id, course_code, course_name, credits, active)
VALUES (30, 'INE101', 'Baze de date în economie', 6, TRUE),
       (30, 'INE102', 'Sisteme informatice economice', 5, TRUE),
       (30, 'INE103', 'Algoritmi pentru optimizări economice', 5, TRUE),
       (30, 'INE104', 'E-business', 5, TRUE),
       (30, 'INE105', 'Programare pentru aplicații economice', 6, TRUE),
       (30, 'INE201', 'Business intelligence', 5, TRUE),
       (30, 'INE202', 'Analiza datelor în economie', 5, TRUE),
       (30, 'INE203', 'Managementul proiectelor informatice', 5, TRUE),
       (30, 'INE204', 'Securitatea sistemelor informatice economice', 5, TRUE),
       (30, 'INE205', 'Tehnologii web pentru economie', 5, TRUE);