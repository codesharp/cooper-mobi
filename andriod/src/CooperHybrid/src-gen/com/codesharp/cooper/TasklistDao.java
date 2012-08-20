package com.codesharp.cooper;

import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteStatement;

import de.greenrobot.dao.AbstractDao;
import de.greenrobot.dao.DaoConfig;
import de.greenrobot.dao.Property;

import com.codesharp.cooper.Tasklist;

// THIS CODE IS GENERATED BY greenDAO, DO NOT EDIT.
/** 
 * DAO for table TASKLIST.
*/
public class TasklistDao extends AbstractDao<Tasklist, Long> {

    public static final String TABLENAME = "TASKLIST";

    /**
     * Properties of entity Tasklist.<br/>
     * Can be used for QueryBuilder and for referencing column names.
    */
    public static class Properties {
        public final static Property Id = new Property(0, Long.class, "id", true, "_id");
        public final static Property AccountId = new Property(1, String.class, "accountId", false, "ACCOUNT_ID");
        public final static Property CreateTime = new Property(2, java.util.Date.class, "createTime", false, "CREATE_TIME");
        public final static Property Editable = new Property(3, Boolean.class, "editable", false, "EDITABLE");
        public final static Property Extensions = new Property(4, String.class, "extensions", false, "EXTENSIONS");
        public final static Property TasklistId = new Property(5, String.class, "tasklistId", false, "TASKLIST_ID");
        public final static Property ListType = new Property(6, String.class, "listType", false, "LIST_TYPE");
        public final static Property Name = new Property(7, String.class, "name", false, "NAME");
    };


    public TasklistDao(DaoConfig config) {
        super(config);
    }
    
    public TasklistDao(DaoConfig config, DaoSession daoSession) {
        super(config, daoSession);
    }

    /** Creates the underlying database table. */
    public static void createTable(SQLiteDatabase db, boolean ifNotExists) {
        String constraint = ifNotExists? "IF NOT EXISTS ": "";
        db.execSQL("CREATE TABLE " + constraint + "'TASKLIST' (" + //
                "'_id' INTEGER PRIMARY KEY AUTOINCREMENT ," + // 0: id
                "'ACCOUNT_ID' TEXT," + // 1: accountId
                "'CREATE_TIME' INTEGER," + // 2: createTime
                "'EDITABLE' INTEGER," + // 3: editable
                "'EXTENSIONS' TEXT," + // 4: extensions
                "'TASKLIST_ID' TEXT," + // 5: tasklistId
                "'LIST_TYPE' TEXT," + // 6: listType
                "'NAME' TEXT);"); // 7: name
    }

    /** Drops the underlying database table. */
    public static void dropTable(SQLiteDatabase db, boolean ifExists) {
        String sql = "DROP TABLE " + (ifExists ? "IF EXISTS " : "") + "'TASKLIST'";
        db.execSQL(sql);
    }

    /** @inheritdoc */
    @Override
    protected void bindValues(SQLiteStatement stmt, Tasklist entity) {
        stmt.clearBindings();
 
        Long id = entity.getId();
        if (id != null) {
            stmt.bindLong(1, id);
        }
 
        String accountId = entity.getAccountId();
        if (accountId != null) {
            stmt.bindString(2, accountId);
        }
 
        java.util.Date createTime = entity.getCreateTime();
        if (createTime != null) {
            stmt.bindLong(3, createTime.getTime());
        }
 
        Boolean editable = entity.getEditable();
        if (editable != null) {
            stmt.bindLong(4, editable ? 1l: 0l);
        }
 
        String extensions = entity.getExtensions();
        if (extensions != null) {
            stmt.bindString(5, extensions);
        }
 
        String tasklistId = entity.getTasklistId();
        if (tasklistId != null) {
            stmt.bindString(6, tasklistId);
        }
 
        String listType = entity.getListType();
        if (listType != null) {
            stmt.bindString(7, listType);
        }
 
        String name = entity.getName();
        if (name != null) {
            stmt.bindString(8, name);
        }
    }

    /** @inheritdoc */
    @Override
    public Long readKey(Cursor cursor, int offset) {
        return cursor.isNull(offset + 0) ? null : cursor.getLong(offset + 0);
    }    

    /** @inheritdoc */
    @Override
    public Tasklist readEntity(Cursor cursor, int offset) {
        Tasklist entity = new Tasklist( //
            cursor.isNull(offset + 0) ? null : cursor.getLong(offset + 0), // id
            cursor.isNull(offset + 1) ? null : cursor.getString(offset + 1), // accountId
            cursor.isNull(offset + 2) ? null : new java.util.Date(cursor.getLong(offset + 2)), // createTime
            cursor.isNull(offset + 3) ? null : cursor.getShort(offset + 3) != 0, // editable
            cursor.isNull(offset + 4) ? null : cursor.getString(offset + 4), // extensions
            cursor.isNull(offset + 5) ? null : cursor.getString(offset + 5), // tasklistId
            cursor.isNull(offset + 6) ? null : cursor.getString(offset + 6), // listType
            cursor.isNull(offset + 7) ? null : cursor.getString(offset + 7) // name
        );
        return entity;
    }
     
    /** @inheritdoc */
    @Override
    public void readEntity(Cursor cursor, Tasklist entity, int offset) {
        entity.setId(cursor.isNull(offset + 0) ? null : cursor.getLong(offset + 0));
        entity.setAccountId(cursor.isNull(offset + 1) ? null : cursor.getString(offset + 1));
        entity.setCreateTime(cursor.isNull(offset + 2) ? null : new java.util.Date(cursor.getLong(offset + 2)));
        entity.setEditable(cursor.isNull(offset + 3) ? null : cursor.getShort(offset + 3) != 0);
        entity.setExtensions(cursor.isNull(offset + 4) ? null : cursor.getString(offset + 4));
        entity.setTasklistId(cursor.isNull(offset + 5) ? null : cursor.getString(offset + 5));
        entity.setListType(cursor.isNull(offset + 6) ? null : cursor.getString(offset + 6));
        entity.setName(cursor.isNull(offset + 7) ? null : cursor.getString(offset + 7));
     }
    
    /** @inheritdoc */
    @Override
    protected Long updateKeyAfterInsert(Tasklist entity, long rowId) {
        entity.setId(rowId);
        return rowId;
    }
    
    /** @inheritdoc */
    @Override
    public Long getKey(Tasklist entity) {
        if(entity != null) {
            return entity.getId();
        } else {
            return null;
        }
    }

    /** @inheritdoc */
    @Override    
    protected boolean isEntityUpdateable() {
        return true;
    }
    
}