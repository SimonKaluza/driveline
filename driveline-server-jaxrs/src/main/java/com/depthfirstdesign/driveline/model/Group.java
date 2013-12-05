// Group.java
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

package com.depthfirstdesign.driveline.model;

import javax.xml.bind.annotation.*;
import java.util.List;

@XmlRootElement(name = "Group")
public class Group {
  private long id;
  private String name;
  private String adminEmail;
  private String description;
  private int usersAdminStatus;

    public int getUsersAdminStatus() {
        return usersAdminStatus;
    }

    public void setUsersAdminStatus(int usersAdminStatus) {
        this.usersAdminStatus = usersAdminStatus;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getDeleted() {
        return deleted;
    }

    public void setDeleted(int deleted) {
        this.deleted = deleted;
    }

    private String address;
  private int deleted;

  @XmlElement(name = "id")
  public long getId() {
    return id;
  }

  public void setId(long id) {
    this.id = id;
  }

  @XmlElement(name = "name")
  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

    @XmlElement(name = "description")
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @XmlElement(name = "adminEmail")
    public String getAdminEmail() {
        return adminEmail;
    }

    public void setAdminEmail(String adminEmail) {
        this.adminEmail = adminEmail;
    }

    public Group(){

    }

    public Group(long id, String name, String adminEmail, String description, int deleted, String address) {
        this.id = id;
        this.name = name;
        this.adminEmail = adminEmail;
        this.description = description;
        this.deleted = deleted;
        this.address = address;
    }
}
