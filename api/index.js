const express = require('express');
const app = express();
const nodemon = require('nodemon');
app.use(express.json());

//Mongoose package
const mongoose = require('mongoose');

const PORT = 1200;

const dbURL = "mongodb+srv://admin:sh5jwTIMzsXp7bxa@cluster0.7h34syv.mongodb.net/?retryWrites=true&w=majority";

//Mongoose connection
mongoose.connect(dbURL,
{
    useNewUrlParser: true,
    useUnifiedTopology: true
});

const db = mongoose.connection;

//Error handler
db.on('error', () => {
    console.error.bind(console, 'connection error: ');
});
db.once('open', () => {
    console.log('MongoDB Connected');
});

/*
Setting model paths
*/
require('./models/Course');
require('./models/Student');

const Student = mongoose.model('Student');
const Course = mongoose.model('Course');

//Initial server connection validation
app.get('/', (req, res) => {
    return res.status(200).json("(Message: OK)");
});

/*
Add paths
*/
app.post('/addStudent', async (req, res) => {
    try{
        let stud = {
            fname: req.body.fname,
            lname: req.body.lname,
            studentID: req.body.studentID
        }
        await Student(stud).save().then(c => {
            return res.status(201).json("Student added")});
    }
    catch{
        return res.status(500).json("Bad student data");
    }
});
app.post('/addCourse', async (req, res) => {
    try{
        let cour = {
            courseInstructor: req.body.courseInstructor,
            courseCredits: req.body.courseCredits,
            courseID: req.body.courseID,
            courseName: req.body.courseName
        }
        await Course(cour).save().then(c => {
            return res.status(201).json("Course added")});
    }
    catch{
        return res.status(500).json("Bad course data");
    }
});

/*
find paths
*/
app.get('/findStudent', async (req,res) => {
    try{
    let stud = await Student.findOne(req.body);  
    return res.status(200).json(stud);
    }
    catch{
        return res.status(500).json("No Student found");
    }
});

app.get('/findCourse', async (req,res) => {
    try{
    let cour = await Course.findOne(req.body);  
    return res.status(200).json(cour);
    }
    catch{
        return res.status(500).json("No Course found");
    }
});

/*
findAll paths
*/
app.get('/findAllStudents', async (req, res) => {
    try{
        let stud = await Student.find({}).lean();
        return res.status(200).json({ "student": stud });
    }
    catch{
        return res.status(500).json("Couldn't access students");
    }
});

app.get('/findAllCourses', async (req, res) => {
    try{
        let cour = await Course.find({}).lean();
        return res.status(200).json({ "course": cour });
    }
    catch{
        return res.status(500).json("Couldn't access courses");
    }
});

app.listen(PORT, () => {
    console.log(`Server Started on port ${PORT}`);
});

/*
update paths
*/
app.post('/updateStudentById', async (req,res) =>{
    try{
       let stud = await Student.updateOne({_id: req.body.id}
        , {
            fname: req.body.fname
        }, {upsert: false});
        if(stud) {
            return res.status(200).json("Student fname updated")
        } else {
            return res.status(200).json("No student by given id found");
        };
    }  
    catch{
        return res.status(500).json("Couldn't find student to update");
    }
});

app.post('/updateStudentByFname', async (req,res) =>{
    try{
        let stud = await Student.findOneAndUpdate({fname: req.body.queryFname}
            , {
                fname: req.body.fname, 
                lname: req.body.lname
            }, {upsert: false});
        if(stud) {
            return res.status(200).json("Student fname and lname updated");
        } else {
            return res.status(200).json("No student by given fname");
        }
    }
    catch{
        return res.status(500).json("Couldn't find student to update");
    };
});

app.post('/updateCourseByCourseName', async (req,res) => {
    try{
        let cour = await Course.updateOne({courseName: req.body.courseName}
            , {
                courseInstructor: req.body.courseInstructor
            }, {upsert: true});
            if(cour) {
                return res.status(200).json("Updated course instructor");
            } else {
                return res.status(200).json("No course by given course id");
            }
    }
    catch{
        return res.status(500).json("Couldn't find course to update");
    }
});

/*
delete paths
*/
app.post('/deleteCourseById', async (req,res) => {
    try{
        let cour = await Course.findOne({_id: req.body.id});

        if(cour) {
            await Course.deleteOne({_id: req.body.id});
            return res.status(200).json("Course deleted");
        } else {
            return res.status(200).json("Couldn't find course by given id, no delete action taken")
        };
    }
    catch{
        return res.status(500).json("Couldn't find course to delete");
    }
});

app.post('/removeStudentFromClasses', async (req,res) => {
    try{
        let stud = await Student.findOne({_id: req.body.id});

        if(stud) {
            await Student.deleteOne({_id: req.body.id});
            return res.status(200).json("Student removed from classes");
        } else {
            return res.status(200).json("Couldn't find student by given fname, no delete action taken");
        }
    }
    catch{
        return res.status(500).json("No student found")
    }
});