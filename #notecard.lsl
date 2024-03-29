integer slider4;
integer intLine1;
string  note_name;
key keyConfigQueryhandle;
key keyConfigUUID;

integer getLinkNum(string primName)
{
integer primCount = llGetNumberOfPrims();
integer i;
for (i=0; i<primCount+1;i++){  
if (llGetLinkName(i)==primName) return i;
}
return FALSE;
}
integer readnote(string notename)
{
  if (llGetInventoryType(notename) == INVENTORY_SOUND)
  {
  llMessageLinked(LINK_THIS,0,"upload_note|idle_music=" +(string)llGetInventoryKey(notename),"");
  llSetLinkPrimitiveParamsFast(slider4,[PRIM_DESC,"1"]);
  return 2;
  }
  if (llGetInventoryType(notename) == INVENTORY_NOTECARD)
  {
  note_name = notename; intLine1 = 0;
  keyConfigQueryhandle = llGetNotecardLine(notename, intLine1);
  keyConfigUUID = llGetInventoryKey(notename);
  llSetLinkPrimitiveParamsFast(slider4,[PRIM_DESC,"0"]);
  return 1;
  }
  llMessageLinked(LINK_THIS,0,"upload_note|idle_music="+notename,"");
  llSetLinkPrimitiveParamsFast(slider4,[PRIM_DESC,"1"]);
  return 2;
}
default 
{ 
    changed(integer change)
    {
    if(change & CHANGED_INVENTORY){llResetScript();}
    }
    on_rez(integer start_param) 
    {
    llResetScript();
    }
    state_entry() 
    {
    slider4 = getLinkNum("slider4");
    llSetLinkPrimitiveParamsFast(slider4,[PRIM_DESC,"0"]);
    llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS);
    }
    run_time_permissions(integer perm)
    {
    if(PERMISSION_TAKE_CONTROLS & perm){llTakeControls( CONTROL_BACK|CONTROL_FWD, TRUE, TRUE );}
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
    list params = llParseString2List(msg, ["|"], []);
    if(llList2String(params, 0) == "fetch_note_rationed")
    {
      integer value = readnote(llList2String(params,1));
      if(value == 2){llMessageLinked(LINK_THIS,0,"music_changed","");}
    } }
    dataserver(key keyQueryId, string strData)
    {
    if (keyQueryId == keyConfigQueryhandle)
    {
          if (strData == EOF){llMessageLinked(LINK_THIS,0,"music_changed","");}else
          {
             keyConfigQueryhandle = llGetNotecardLine(note_name, ++intLine1);
             llMessageLinked(LINK_THIS,0,"upload_note|" + strData,"");
    }  }  }  }
