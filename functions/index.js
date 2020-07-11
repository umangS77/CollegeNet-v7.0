const functions = require('firebase-functions');
const admin=require('firebase-admin');
admin.initializeApp(functions.config().firebase);
exports.NewEvent = functions.database.ref('events/{id}')
.onCreate((snap,evt) => {
    const payload = {
        notification:{
            title : "New Event Added - " + snap.val().title,
            body : "Checkout the New Event Added",
            badge : "1",
            sound : "default",
            image : snap.val().imageURL,
        }
    };
    
    return admin.database().ref('fcm-token').once('value').then(allToken => {
        if(allToken.val()){
            console.log("Token available");
            const token = Object.keys(allToken.val());
            return admin.messaging().sendToDevice(token,payload);
        }
        else
        {
            console.log("No Token available");
            return;
        }
    });
});
exports.NewAnnouncement = functions.firestore.document('announcements/{id}')
.onCreate((snapshot,context) => {
    const payload2 = {
        notification:{
            title : "Announcement Alert - " + snapshot.data().caption,
            body : snapshot.data().content,
            clickAction : 'FLUTTER_NOTIFICATION_CLICK',
            badge : "1",
            sound : "default"
        }
    };
    return admin.database().ref('fcm-token').once('value').then(allToken=> {
        if(allToken.val()){
            console.log("Token available");
            const token = Object.keys(allToken.val());
            return admin.messaging().sendToDevice(token,payload2);
        }
        else
        {
            console.log("No token available");
            return;
        }
    });
})