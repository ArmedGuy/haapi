module.exports = (db, Schema, ObjectId) ->
	BackendServer = new Schema
		name:
			type: String
		path:
			type: String
		options:
			type: String
	db.model 'BackendServer', BackendServer

	Backend = new Schema
		name:
			type: String
		balance:
			type: String
			default: 'roundrobin'
		mode:
			type: String
		options: [String]
		servers: [BackendServer]
	db.model 'Backend', Backend

	UseBackend = new Schema
		backend: Backend
		ifs:
			type: String
	db.model 'UseBackend', UseBackend

	ACL = new Schema
		name:
			type: String
		cond:
			type: String
	db.model 'ACL', ACL

	Frontend = new Schema
		bind:
			type: String
			default: '*:80'
		mode:
			type: String
			default: 'http'
		options: [String]
		acl: [ACL]
		use: [UseBackend]
		default_use: Backend
	db.model 'Frontend', Frontend

	Config = new Schema
		name:
			type: String
		generalConfig:
			type: String
		frontends: [Frontend]
		backends: [Backend]
	db.model 'Config', Config

	ProxyServer = new Schema
		address:
			type: String
			required: true
			unique: true
		port:
			type: Number
			default: 22
		user:
			type: String
			default: 'haapi'
		privateKey:
			type: String
			default: '/home/haapi/.ssh/id_rsa'
		status:
			canConnect: Boolean
			canAccessConfig: Boolean
			isStarted: Boolean
		configFile:
			type: String
			default: '/etc/haproxy/haproxy.cfg'
		activeConfig: Config
	db.model 'ProxyServer', ProxyServer
