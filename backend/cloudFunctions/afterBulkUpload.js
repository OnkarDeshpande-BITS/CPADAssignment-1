 Parse.Cloud.afterSaveFile(async (request) => {
   const { file, fileSize, user } = request;
  const bulkUpload = new Parse.Object('BulkUploadDetails');
  bulkUpload.set('fileName', file.name());
  bulkUpload.set('size', fileSize);
  bulkUpload.set('addedBy', file.metadata().addedBy);
  bulkUpload.set('uploadType',file.metadata().type);
  bulkUpload.set('url', file.url());
  await bulkUpload.save();
});