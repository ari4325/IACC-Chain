// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "./IACCNFT.sol";

contract IACCCore {

    struct Project{
        address user;
        string project_name;
        string project_description;
        uint tokenId;
    }

   mapping(address => Project[]) userProjects;
   mapping(address => uint[]) userTokens;

   mapping(uint => Project) tokenToProject;
   mapping(uint => address) tokenToUser;
   mapping(uint => bool) tokenProjectStatus;

   Project[] projects; 

   address _owner;
   IACCNFT _tokenContract;

   event ProjectCreated(address indexed user, string indexed name, uint indexed tokenID) ; 

   modifier isActiveProject(){_;}

  constructor(address _NFTProject) {
      _owner = msg.sender;
      _tokenContract = IACCNFT(_NFTProject);
  }

  function createProject(string memory projectName, string memory project_desc, string memory uri) external returns (uint){
      uint token = _tokenContract.createToken(msg.sender, uri);
      Project memory prj = Project(msg.sender, projectName, project_desc, token);

      tokenProjectStatus[token] = true;
      tokenToProject[token] = prj;
      tokenToUser[token] = msg.sender;

      userTokens[msg.sender].push(token);
      userProjects[msg.sender].push(prj);

      projects.push(prj);

      return token;
  }

  function getUserTokens() external view returns(uint[] memory){
      return userTokens[msg.sender];
  }

  function getUserTokens(address _user) external view returns(uint[] memory){
      return userTokens[_user];
  }

  function getUserTokenCount() external view returns(uint){
      return userTokens[msg.sender].length;
  }

  function getUserTokenCount(address _user) external view returns(uint){
      return userTokens[_user].length;
  }

  function getProjectData(uint _token) external view returns (Project memory) {
      return tokenToProject[_token];
  }
}