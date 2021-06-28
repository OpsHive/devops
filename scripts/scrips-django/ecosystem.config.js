module.exports = {
  apps : [{
    name: 'cogniable_frontend',
    cwd: '/home/ubuntu/cogniable/react_module',
    script: 'npm',
    args: 'start',
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    port:3000
  },{
    name: 'cogniable_annotation',
    cwd: '/home/ubuntu/cogniable/annotation_tool/cogniable_annotation_frontend',
    script: 'npm',
    args: 'start',
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    port:3001
  }]
};


