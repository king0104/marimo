### jenkins pipeline
- DB 비밀번호는 실제 비밀번호 대신 {password}를 적어두었습니다.

pipeline {
agent any

    environment {
        // Docker 관련 설정
        DOCKER_IMAGE_NAME     = 'andres2222/marimo-be-api-dev' // Docker Hub에 저장할 이미지 이름
        DOCKER_CREDENTIALS_ID = 'dockerhub'                   // Docker Hub 자격 증명 ID
        
        // API 서버 관련 설정
        API_EC2_IP         = 'j12a605.p.ssafy.io' // 실제 API 서버 IP
        API_EC2_USER       = 'ubuntu'             // API 서버 사용자 (예: ubuntu)
        API_CONTAINER_NAME = 'api_marimo'         // API 서버에서 실행할 컨테이너 이름
    }

    stages {
        stage('Clone') {
            steps {
                git branch: 'be/dev', credentialsId: 'gitlab-access', url: 'https://lab.ssafy.com/s12-fintech-finance-sub1/S12P21A605.git'
                // 클론 결과 확인
                sh 'ls -la'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Repository 루트에 있는 Dockerfile을 이용해 Docker 이미지 빌드
                    dockerImage = docker.build("${DOCKER_IMAGE_NAME}")
                }
            }
        }
        
        // Docker Hub에 push하는 단계 (필요 없으면 주석 처리)
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CREDENTIALS_ID}") {
                        // 빌드번호 태그와 latest 태그로 이미지 푸시
                        dockerImage.push("${env.BUILD_NUMBER}")
                        dockerImage.push('latest')
                    }
                }
            }
        }
        
        
        stage('Deploy to API Server') {
            steps {
                sshagent(credentials: ['jenkins_key']) { // Jenkins에 등록된 SSH 자격 증명 ID 사용
                    sh """
                    ssh -o StrictHostKeyChecking=no ${API_EC2_USER}@${API_EC2_IP} << 'EOF'
                        echo "### Docker 이미지 풀링 중..."
                        sudo docker pull ${DOCKER_IMAGE_NAME}:latest
                        
                        echo "### 컨테이너 중지 및 제거..."
                        sudo docker stop ${API_CONTAINER_NAME} || true
                        sudo docker rm ${API_CONTAINER_NAME} || true
                        
                        echo "### 새 컨테이너 실행 중..."
                        sudo docker run -d --name ${API_CONTAINER_NAME} \\
                            --restart unless-stopped \\
                            -p 8080:8080 \\
                            -e DB_DRIVER_CLASS_NAME="com.mysql.cj.jdbc.Driver" \\
                            -e DB_URL="jdbc:mysql://marimoss.c524ku4mqkhx.us-east-2.rds.amazonaws.com:3306/marimo" \\
                            -e DB_USERNAME="admin" \\
                            -e DB_PASSWORD="{password}" \\
                            -e ENCRYPT_SECRET_KEY="3eee1c782a80fa791af57e535541398a" \\
                            -e JWT_SECRET_KEY="Kl4Xi5qAz6JmUeYoPJArEWQXxoHgfBKyFNIYXRDGN/M=" \\
                            -e GMAIL_SMTP_ID="encjf2070" \\
                            -e GMAIL_SMTP_PASSWORD="jomivodoowgpqohz" \\
                            -e SSAFY_API_KEY="c106881378b8484da90dd348b6c605dc" \\
                            -e SSAFY_USER_KEY="3c53b588-8a9b-4625-b24f-5d006ad4d5c8" \\
                            -e OPINET_KEY="F250330221" \\
                            ${DOCKER_IMAGE_NAME}:latest
                        
                        echo "### 컨테이너 실행 상태 확인..."
                        if ! sudo docker ps | grep -q ${API_CONTAINER_NAME}; then
                            echo "컨테이너 실행에 실패했습니다."
                            exit 1
                        fi
                        
                        echo "### 불필요한 dangling 이미지 제거..."
                        IMAGES=\$(sudo docker images -f 'dangling=true' -q)
                        if [ -n "\$IMAGES" ]; then
                            sudo docker rmi -f \$IMAGES || true
                        else
                            echo "정리할 dangling 이미지가 없습니다."
                        fi
EOF
"""
}
}
}
}

    post {
        success {
            echo "파이프라인이 성공적으로 완료되었습니다."
        }
        failure {
            echo "파이프라인 실행 중 오류가 발생했습니다."
        }
        always {
            cleanWs() // 작업 공간 정리
        }
    }
}
