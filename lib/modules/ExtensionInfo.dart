class ExtensionInfo {
  String name = ""; 
  String logoURL = ""; 
  String siteURL = ""; 

  ExtensionInfo(this.name,this.siteURL,this.logoURL);

  @override
  String toString() {
    return "ExtensionInfo(name: $name, siteURL: ${siteURL.substring(0,16)}...)";
  }
}