<%@page pageEncoding="UTF-8"%>
<%!
    public String isChecked(String str1, String str2) throws Exception{
        if (str1 == null || str2 == null) {
            return "";
        }else if (str1.equals(str2)){
            return "checked";
        }
        else if(str1.indexOf(str2)>-1){
            return "checked";
        }
        else {
            return "";
        }
    }

    public String isSelected(String str1, String str2){
        if (str1 != null && str1.equals(str2)){
        return "selected";
        }
        return "";
    }

    String req(String Name,HttpServletRequest requ) throws Exception
    {
       String Value=requ.getParameter(Name);
       if(Value==null) Value="";
       return Value;
    }

    String reqValues(String Name, HttpServletRequest requ) throws Exception{
        String[] Hobbies = requ.getParameterValues(Name);
        String hobbStr = "";

        if (Hobbies != null){
            hobbStr = String.join(",", Hobbies);
        }
        hobbStr = ","+hobbStr+",";
        return hobbStr;
    }

    boolean isPost(javax.servlet.http.HttpServletRequest requ)
    {
        if(requ.getMethod().toString().equals("GET"))
            return false;
        else
            return true;
    }

    public String toStr(String Value){
        return "'" + Value.replaceAll("'", "''") + "'";
    }



    public void setSession(String Name, String Value, javax.servlet.http.HttpSession Session){
        Session.setAttribute(Name, Value);
    }

    public String getSession(String Name, javax.servlet.http.HttpSession Session){
        if (Session == null) return "";
        String value = (String)Session.getAttribute(Name);
        if( value != null) return value;
        return "";
    }
    
%>