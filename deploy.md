# deploy
```
1. k8s 설치 완료 
	-. argo cd 설치 완료
	-. mysql 설치
	-. wildfly 설치 - https://diary.dev9.shop/ - WildFly instance is running.
	
4.  jsp war maven github 프로젝트 완료 - https://github.com/sangbinlee/dev9-web-lon-001
	-. step
		1. 소스 수정 후 푸시 - https://github.com/sangbinlee/dev9-web-lon-001
		2. github actions 
			- build war
			- Build and Push Docker Image
			- deployment.yaml 수정 후 push
		3. argo cd 변경 인식하기 위한 application 생성
	-. Dockerfile
		```
			FROM quay.io/wildfly/wildfly:latest
			COPY target/lon.war /opt/jboss/wildfly/standalone/deployments/lon.war
		```
	-. deployment.yaml
		```
			apiVersion: apps/v1
			kind: Deployment
			metadata:
			  name: wildfly-app
			  labels:
			    app: wildfly-app
			spec:
			  replicas: 2
			  selector:
			    matchLabels:
			      app: wildfly-app
			  template:
			    metadata:
			      labels:
			        app: wildfly-app
			    spec:
			      containers:
			        - name: wildfly-app
			          image: ghcr.io/sangbinlee/dev9-web-lon-001:a8b35d2165ffc587cbe4783cf1f3ff383ea7b88f
			          ports:
			            - containerPort: 8080
			            - containerPort: 9404
			          env:
			            - name: JAVA_OPTS
			              value: "-Djava.util.logging.manager=org.jboss.logmanager.LogManager"
			---
			apiVersion: v1
			kind: Service
			metadata:
			  name: wildfly-service
			  labels:
			    app: wildfly-app
			spec:
			  selector:
			    app: wildfly-app
			  ports:
			    - protocol: TCP
			      port: 80
			      targetPort: 8080
			      name: http
			    - protocol: TCP
			      port: 9404
			      targetPort: 9404
			      name: metrics
			  type: ClusterIP
			---
			apiVersion: networking.k8s.io/v1
			kind: Ingress
			metadata:
			  name: wildfly-ingress
			  annotations:
			    cert-manager.io/cluster-issuer: letsencrypt-prod
			spec:
			  ingressClassName: nginx
			  tls:
			  - hosts:
			    - diary.dev9.shop
			    secretName: wildfly-tls
			  rules:
			  - host: diary.dev9.shop
			    http:
			      paths:
			      - path: /
			        pathType: Prefix
			        backend:
			          service:
			            name: wildfly-service
			            port:
			              number: 80
			---
			apiVersion: autoscaling/v2
			kind: HorizontalPodAutoscaler
			metadata:
			  name: wildfly-hpa
			spec:
			  scaleTargetRef:
			    apiVersion: apps/v1
			    kind: Deployment
			    name: wildfly-app
			  minReplicas: 2
			  maxReplicas: 10
			  metrics:
			  - type: Resource
			    resource:
			      name: cpu
			      target:
			        type: Utilization
			        averageUtilization: 70	
		```
	-. deploy.yml
		```
			name: CI/CD to Kubernetes
			
			on:
			  push:
			    branches:
			      - main
			
			permissions:
			  packages: write
			  contents: write
			
			jobs:
			  build-and-deploy:
			    runs-on: ubuntu-latest
			    steps:
			    - name: Checkout web project
			      uses: actions/checkout@v3
			      with:
			        fetch-depth: 0
			
			    - name: Checkout parent project
			      uses: actions/checkout@v3
			      with:
			        repository: sangbinlee/dev9-parent
			        path: dev9-parent
			
			    - name: Checkout core project
			      uses: actions/checkout@v3
			      with:
			        repository: sangbinlee/dev9-core
			        path: dev9-core
			
			    - name: Checkout ejb-lon project
			      uses: actions/checkout@v3
			      with:
			        repository: sangbinlee/dev9-ejb-lon-001
			        path: dev9-ejb-lon-001
			
			    - name: Set up JDK 21
			      uses: actions/setup-java@v3
			      with:
			        java-version: '21'
			        distribution: 'temurin'
			        cache: 'maven'
			
			    - name: Build parent modules
			      run: mvn clean install -DskipTests
			      working-directory: ./dev9-parent
			
			    - name: Build core module
			      run: mvn clean install -DskipTests
			      working-directory: ./dev9-core
			
			    - name: Build ejb-lon module
			      run: mvn clean install -DskipTests
			      working-directory: ./dev9-ejb-lon-001
			
			    - name: Build web module
			      run: mvn clean package -DskipTests
			      working-directory: .
			
			    - name: Log in to GitHub Container Registry
			      uses: docker/login-action@v2
			      with:
			        registry: ghcr.io
			        username: ${{ github.actor }}
			        password: ${{ secrets.GITHUB_TOKEN }}
			
			    - name: Build and Push Docker Image
			      run: |
			        IMAGE=ghcr.io/${{ github.repository_owner }}/dev9-web-lon-001:${{ github.sha }}
			        docker build -t $IMAGE .
			        		
			        docker push $IMAGE
			
			    - name: Check deployments directory inside container
			      run: |
			        IMAGE=ghcr.io/${{ github.repository_owner }}/dev9-web-lon-001:${{ github.sha }}
			        docker run --rm $IMAGE ls -l /opt/jboss/wildfly/standalone/deployments/
			
			    - name: Update Kubernetes manifest with new image tag
			      run: |
			        sed -i "s|image: ghcr.io/${{ github.repository_owner }}/dev9-web-lon-001:.*|image: ghcr.io/${{ github.repository_owner }}/dev9-web-lon-001:${{ github.sha }}|" deployment.yaml
			
			    - name: Commit and Push changes
			      run: |
			        git config --global user.name "github-actions[bot]"
			        git config --global user.email "github-actions[bot]@users.noreply.github.com"
			        git add deployment.yaml
			
			        git commit -m "Update image tag to ${{ github.sha }}" || echo "No changes to commit"
			        git pull --rebase https://x-access-token:${{ secrets.GITHUB_TOKEN }}@github.com/${{ github.repository }} main
			        git push https://x-access-token:${{ secrets.GITHUB_TOKEN }}@github.com/${{ github.repository }} HEAD:main
			
			 
		
		```
5. 소스 푸시 시 argo cd  자동 배포 원함
```
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 