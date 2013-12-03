// UserStatus.java
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

package com.depthfirstdesign.driveline.model;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class UserStatus {
  private long groupId;
  private int status;

    @XmlElement
    public long getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }



  @XmlElement
  public long getGroupId() {
    return groupId;
  }

  public void setGroupId(long groupId) {
    this.groupId = groupId;
  }
}