package com.codesharp.cooper;

import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteStatement;

import de.greenrobot.dao.AbstractDao;
import de.greenrobot.dao.DaoConfig;
import de.greenrobot.dao.Property;

import com.codesharp.cooper.Task;

// THIS CODE IS GENERATED BY greenDAO, DO NOT EDIT.
/** 
 * DAO for table TASK.
*/
public class TaskDao extends AbstractDao<Task, Long> {

    public static final String TABLENAME = "TASK";

    /**
     * Properties of entity Task.<br/>
     * Can be used for QueryBuilder and for referencing column names.
    */
    public static class Properties {
        public final static Property Id = new Property(0, Long.class, "id", true, "_id");
        public final static Property AccountId = new Property(1, String.class, "accountId", false, "ACCOUNT_ID");
        public final static Property Body = new Property(2, String.class, "body", false, "BODY");
        public final static Property CreateDate = new Property(3, java.util.Date.class, "createDate", false, "CREATE_DATE");
        public final static Property DueDate = new Property(4, java.util.Date.class, "dueDate", false, "DUE_DATE");
        public final static Property TaskId = new Property(5, String.class, "taskId", false, "TASK_ID");
        public final static Property IsPublic = new Property(6, Boolean.class, "isPublic", false, "IS_PUBLIC");
        public final static Property LastUpdateDate = new Property(7, java.util.Date.class, "lastUpdateDate", false, "LAST_UPDATE_DATE");
        public final static Property Priority = new Property(8, String.class, "priority", false, "PRIORITY");
        public final static Property Status = new Property(9, Integer.class, "status", false, "STATUS");
        public final static Property Editable = new Property(10, Boolean.class, "editable", false, "EDITABLE");
        public final static Property Subject = new Property(11, String.class, "subject", false, "SUBJECT");
        public final static Property TasklistId = new Property(12, String.class, "tasklistId", false, "TASKLIST_ID");
    };


    public TaskDao(DaoConfig config) {
        super(config);
    }
    
    public TaskDao(DaoConfig config, DaoSession daoSession) {
        super(config, daoSession);
    }

    /** Creates the underlying database table. */
    public static void createTable(SQLiteDatabase db, boolean ifNotExists) {
        String constraint = ifNotExists? "IF NOT EXISTS ": "";
        db.execSQL("CREATE TABLE " + constraint + "'TASK' (" + //
                "'_id' INTEGER PRIMARY KEY AUTOINCREMENT ," + // 0: id
                "'ACCOUNT_ID' TEXT," + // 1: accountId
                "'BODY' TEXT," + // 2: body
                "'CREATE_DATE' INTEGER," + // 3: createDate
                "'DUE_DATE' INTEGER," + // 4: dueDate
                "'TASK_ID' TEXT," + // 5: taskId
                "'IS_PUBLIC' INTEGER," + // 6: isPublic
                "'LAST_UPDATE_DATE' INTEGER," + // 7: lastUpdateDate
                "'PRIORITY' TEXT," + // 8: priority
                "'STATUS' INTEGER," + // 9: status
                "'EDITABLE' INTEGER," + // 10: editable
                "'SUBJECT' TEXT," + // 11: subject
                "'TASKLIST_ID' TEXT);"); // 12: tasklistId
    }

    /** Drops the underlying database table. */
    public static void dropTable(SQLiteDatabase db, boolean ifExists) {
        String sql = "DROP TABLE " + (ifExists ? "IF EXISTS " : "") + "'TASK'";
        db.execSQL(sql);
    }

    /** @inheritdoc */
    @Override
    protected void bindValues(SQLiteStatement stmt, Task entity) {
        stmt.clearBindings();
 
        Long id = entity.getId();
        if (id != null) {
            stmt.bindLong(1, id);
        }
 
        String accountId = entity.getAccountId();
        if (accountId != null) {
            stmt.bindString(2, accountId);
        }
 
        String body = entity.getBody();
        if (body != null) {
            stmt.bindString(3, body);
        }
 
        java.util.Date createDate = entity.getCreateDate();
        if (createDate != null) {
            stmt.bindLong(4, createDate.getTime());
        }
 
        java.util.Date dueDate = entity.getDueDate();
        if (dueDate != null) {
            stmt.bindLong(5, dueDate.getTime());
        }
 
        String taskId = entity.getTaskId();
        if (taskId != null) {
            stmt.bindString(6, taskId);
        }
 
        Boolean isPublic = entity.getIsPublic();
        if (isPublic != null) {
            stmt.bindLong(7, isPublic ? 1l: 0l);
        }
 
        java.util.Date lastUpdateDate = entity.getLastUpdateDate();
        if (lastUpdateDate != null) {
            stmt.bindLong(8, lastUpdateDate.getTime());
        }
 
        String priority = entity.getPriority();
        if (priority != null) {
            stmt.bindString(9, priority);
        }
 
        Integer status = entity.getStatus();
        if (status != null) {
            stmt.bindLong(10, status);
        }
 
        Boolean editable = entity.getEditable();
        if (editable != null) {
            stmt.bindLong(11, editable ? 1l: 0l);
        }
 
        String subject = entity.getSubject();
        if (subject != null) {
            stmt.bindString(12, subject);
        }
 
        String tasklistId = entity.getTasklistId();
        if (tasklistId != null) {
            stmt.bindString(13, tasklistId);
        }
    }

    /** @inheritdoc */
    @Override
    public Long readKey(Cursor cursor, int offset) {
        return cursor.isNull(offset + 0) ? null : cursor.getLong(offset + 0);
    }    

    /** @inheritdoc */
    @Override
    public Task readEntity(Cursor cursor, int offset) {
        Task entity = new Task( //
            cursor.isNull(offset + 0) ? null : cursor.getLong(offset + 0), // id
            cursor.isNull(offset + 1) ? null : cursor.getString(offset + 1), // accountId
            cursor.isNull(offset + 2) ? null : cursor.getString(offset + 2), // body
            cursor.isNull(offset + 3) ? null : new java.util.Date(cursor.getLong(offset + 3)), // createDate
            cursor.isNull(offset + 4) ? null : new java.util.Date(cursor.getLong(offset + 4)), // dueDate
            cursor.isNull(offset + 5) ? null : cursor.getString(offset + 5), // taskId
            cursor.isNull(offset + 6) ? null : cursor.getShort(offset + 6) != 0, // isPublic
            cursor.isNull(offset + 7) ? null : new java.util.Date(cursor.getLong(offset + 7)), // lastUpdateDate
            cursor.isNull(offset + 8) ? null : cursor.getString(offset + 8), // priority
            cursor.isNull(offset + 9) ? null : cursor.getInt(offset + 9), // status
            cursor.isNull(offset + 10) ? null : cursor.getShort(offset + 10) != 0, // editable
            cursor.isNull(offset + 11) ? null : cursor.getString(offset + 11), // subject
            cursor.isNull(offset + 12) ? null : cursor.getString(offset + 12) // tasklistId
        );
        return entity;
    }
     
    /** @inheritdoc */
    @Override
    public void readEntity(Cursor cursor, Task entity, int offset) {
        entity.setId(cursor.isNull(offset + 0) ? null : cursor.getLong(offset + 0));
        entity.setAccountId(cursor.isNull(offset + 1) ? null : cursor.getString(offset + 1));
        entity.setBody(cursor.isNull(offset + 2) ? null : cursor.getString(offset + 2));
        entity.setCreateDate(cursor.isNull(offset + 3) ? null : new java.util.Date(cursor.getLong(offset + 3)));
        entity.setDueDate(cursor.isNull(offset + 4) ? null : new java.util.Date(cursor.getLong(offset + 4)));
        entity.setTaskId(cursor.isNull(offset + 5) ? null : cursor.getString(offset + 5));
        entity.setIsPublic(cursor.isNull(offset + 6) ? null : cursor.getShort(offset + 6) != 0);
        entity.setLastUpdateDate(cursor.isNull(offset + 7) ? null : new java.util.Date(cursor.getLong(offset + 7)));
        entity.setPriority(cursor.isNull(offset + 8) ? null : cursor.getString(offset + 8));
        entity.setStatus(cursor.isNull(offset + 9) ? null : cursor.getInt(offset + 9));
        entity.setEditable(cursor.isNull(offset + 10) ? null : cursor.getShort(offset + 10) != 0);
        entity.setSubject(cursor.isNull(offset + 11) ? null : cursor.getString(offset + 11));
        entity.setTasklistId(cursor.isNull(offset + 12) ? null : cursor.getString(offset + 12));
     }
    
    /** @inheritdoc */
    @Override
    protected Long updateKeyAfterInsert(Task entity, long rowId) {
        entity.setId(rowId);
        return rowId;
    }
    
    /** @inheritdoc */
    @Override
    public Long getKey(Task entity) {
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