// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProjectManagement {
    struct Task {
        uint id;
        string name;
        string description;
        address assignedTo;
        bool completed;
    }

    struct Project {
        uint id;
        string name;
        string description;
        address manager;
        uint taskCount;
        mapping(uint => Task) tasks;
    }

    uint public projectCount;
    mapping(uint => Project) public projects;
    mapping(address => bool) public registeredUsers;

    event ProjectCreated(uint indexed projectId, string name, address indexed manager);
    event TaskCreated(uint indexed projectId, uint indexed taskId, string name, address indexed assignedTo);
    event TaskCompleted(uint indexed projectId, uint indexed taskId, address indexed completedBy);

    modifier onlyManager(uint _projectId) {
        require(msg.sender == projects[_projectId].manager);
        _;
    }

    modifier onlyRegisteredUser() {
        require(registeredUsers[msg.sender]);
        _;
    }

    constructor() {
        projectCount = 0;
    }

    function registerUser(address _user) public {
        registeredUsers[_user] = true;
    }

    function createProject(string memory name) public onlyRegisteredUser {
        projectCount++;
       
        emit ProjectCreated(projectCount, name, msg.sender);
    }

    function createTask(uint projectId, string memory name, string memory description, address assignedTo) public onlyManager(projectId) onlyRegisteredUser {
        Project storage project = projects[projectId];
        project.taskCount++;
        project.tasks[project.taskCount] = Task(project.taskCount, name, description, assignedTo, false);
        emit TaskCreated(projectId, project.taskCount, name, assignedTo);
    }

    function completeTask(uint projectId, uint taskId) public onlyRegisteredUser {
        Project storage project = projects[projectId];
        Task storage task = project.tasks[taskId];
        require(task.assignedTo == msg.sender);
        task.completed = true;
        emit TaskCompleted(projectId, taskId, msg.sender);
    }

    function getTask(uint projectId, uint taskId) public view returns (uint, string memory, string memory, address, bool) {
        Project storage project = projects[projectId];
        Task storage task = project.tasks[taskId];
        return (task.id, task.name, task.description, task.assignedTo, task.completed);
    }

    function getProject(uint _projectId) public view returns (uint, string memory, string memory, address, uint) {
        Project storage project = projects[_projectId];
        return (project.id, project.name, project.description, project.manager, project.taskCount);
    }
    
    function listProjects() public view returns (uint[] memory, string[] memory, string[] memory, address[] memory) {
        uint[] memory ids = new uint[](projectCount);
        string[] memory names = new string[](projectCount);
        string[] memory descriptions = new string[](projectCount);
        address[] memory managers = new address[](projectCount);
        
        for (uint i = 1; i <= projectCount; i++) {
            Project storage project = projects[i];
            ids[i-1] = project.id;
            names[i-1] = project.name;
            descriptions[i-1] = project.description;
            managers[i-1] = project.manager;
        }
        
        return (ids, names, descriptions, managers);
    }
    
    function listTasks(uint _projectId) public view returns (uint[] memory, string[] memory, string[] memory, address[] memory, bool[] memory) {
        Project storage project = projects[_projectId];
        uint taskCount = project.taskCount;
        
        uint[] memory ids = new uint[](taskCount);
        string[] memory names = new string[](taskCount);
        string[] memory descriptions = new string[](taskCount);
        address[] memory assignedTos = new address[](taskCount);
        bool[] memory completions = new bool[](taskCount);
        
        for (uint i = 1; i <= taskCount; i++) {
            Task storage task = project.tasks[i];
            ids[i-1] = task.id;
            names[i-1] = task.name;
            descriptions[i-1] = task.description;
            assignedTos[i-1] = task.assignedTo;
            completions[i-1] = task.completed;
        }
        
        return (ids, names, descriptions, assignedTos, completions);
    }
}
