 Parse.Cloud.afterSave("BulkUploadDetails", (request) => {
  const uploadDetails = request.object;
  console.log("Inside file processing")
  Parse.Cloud.httpRequest({ url: uploadDetails.get('url') }).then(function(response) {
 console.log("Retreived file");
  // The file contents are in response.buffer.
  const decodedData = Buffer.from(response.body, 'base64').toString('utf-8');
  console.log("Decoded Data - "+decodedData);
  const headerMaster = new Set(["studentId","aadharNo","name","dob","doseDetails", "schoolDriveId"]);
  var allTextLines = decodedData.split(/\r\n|\n/);
    var headers = allTextLines[0].split(',');
	for (var j=0; j<headers.length; j++) {
			
        if(!headerMaster.has(headers[j])) {
		    console.log("incorrect headers");
		}
    }
   

    for (var i=1; i<allTextLines.length; i++) {
        var data = allTextLines[i].split(',');
        if (data.length == headers.length) {
          let student = new Parse.Object("StudentVaccinationDetails");
          for (var j=0; j<headers.length; j++) {
			  if(data[i] != null && data[i].trim().length > 0) {
               if(headers[j] == "dob" || headers[j] == "class") {
			             student.set(headers[j], parseInt(data[j]));
			         } else {
                   student.set(headers[j], data[j]);
               }
            }
         }
         student.save(); 
        }
    }
   
});
});
