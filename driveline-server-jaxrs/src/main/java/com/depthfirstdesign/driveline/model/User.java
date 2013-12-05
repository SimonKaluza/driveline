// User.java
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

package com.depthfirstdesign.driveline.model;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.wordnik.swagger.annotations.*;

import javax.xml.bind.Unmarshaller;
import javax.xml.bind.annotation.*;

@XmlRootElement(name = "user")
@JsonSerialize(include = JsonSerialize.Inclusion.ALWAYS)
public class User{
  private String firstName;
  private String lastName;
  private String email;
  private String password;
  private String phone;
  private int userStatus;
  private int deleted;
  private int seats;
  private int admin;
  private float lastLatitude;
  private float lastLongitude;

    public float getLastLatitude() {
        return lastLatitude;
    }

    public void setLastLatitude(float lastLatitude) {
        this.lastLatitude = lastLatitude;
    }

    public float getLastLongitude() {
        return lastLongitude;
    }

    public void setLastLongitude(float lastLongitude) {
        this.lastLongitude = lastLongitude;
    }

    @XmlElement(nillable = true)
    public int getDeleted() {
        return deleted;
    }

    public void setDeleted(int deleted) {
        this.deleted = deleted;
    }

  @XmlElement(name = "firstName")
  public String getFirstName() {
    return firstName;
  }

  public void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  @XmlElement(name = "lastName")
  public String getLastName() {
    return lastName;
  }

  public void setLastName(String lastName) {
    this.lastName = lastName;
  }

  @XmlElement(name = "email")
  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  @XmlElement(name = "password")
  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    this.password = password;
  }

  @XmlElement(name = "phone")
  public String getPhone() {
    return phone;
  }

  public void setPhone(String phone) {
    this.phone = phone;
  }

  @XmlElement(name = "userStatus")
  public int getUserStatus() {
    return userStatus;
  }

  public void setUserStatus(int userStatus) {
    this.userStatus = userStatus;
  }

    public void setSeats(int seats) {
        this.seats = seats;
    }

    public int getSeats() {
        return seats;
    }

    public int getAdmin() {
        return admin;
    }

    public void setAdmin(int admin) {
        this.admin = admin;
    }

    public User (String email, String firstName, String lastName, String password, String phone, int seats, float lastLatitude, float lastLongitude) {
        this.setFirstName(firstName);
        this.setLastName(lastName);
        this.setEmail(email);
        this.setPassword(password);
        this.setPhone(phone);
        this.setSeats(seats);
        this.setLastLatitude(lastLatitude);
        this.setLastLongitude(lastLongitude);
    }

    // Default empty constructor required for jackson data binding
    public User() {

    }
}