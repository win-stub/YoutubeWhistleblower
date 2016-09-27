/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package youtube.managedb;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.MongoClient;
import com.mongodb.WriteConcern;

/**
 *
 * @author user
 */
public class ManageDB {

    public DBCollection getCollection(String collectionname,String serveur,int port,String dabasename)
    {
        MongoClient mongo = new MongoClient( serveur , port );
        DB db = mongo.getDB(dabasename);
        DBCollection collection = db.getCollection(collectionname);        
        return collection;
    }
    public void addMetaData(DBCollection collection,BasicDBObject infodbobject)
    {        
        /*File file = new File("/home/user/Stage/MongoDB/P13_2015_NOUIOUA_BOUTITI.pdf"); 		
		 
		GridFS gridfs = new GridFS(db, "downloads");
		GridFSInputFile gfsFile = gridfs.createFile(file);
		gfsFile.setFilename("NOUIOUA_BOUTITI");
                gfsFile.setId("1");
		gfsFile.save(); */
        /**
         *  Insertion de l'objet dans la collection 
         */
        collection.insert(infodbobject, WriteConcern.JOURNALED);  
        /**
         * 
         */
    }
    
    public boolean isExist(String video_id,DBCollection collection)
    {
        boolean is_exist = true;
        BasicDBObject query = new BasicDBObject("_id", video_id);

        int nb_count = collection.find(query).count();

        if(nb_count==0){
        is_exist = false;
        }
        return is_exist;
    }
}
