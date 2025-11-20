// Core application types
export interface User {
  id: string
  email: string
  username: string
  avatar?: string
  createdAt: Date
  updatedAt: Date
}

export interface Lesson {
  id: string
  title: string
  description?: string
  level: number
  type: LessonType
  contentUrl?: string
  pointsValue: number
  order: number
  createdAt: Date
  updatedAt: Date
}

export type LessonType = 'sequential' | 'branching' | 'repetition' | 'combined'

export interface UserProgress {
  id: string
  userId: string
  lessonId: string
  completed: boolean
  completedAt?: Date
  timeSpent: number
  score?: number
  createdAt: Date
  updatedAt: Date
}

export interface QuizQuestion {
  id: string
  lessonId: string
  question: string
  type: QuizQuestionType
  options?: string[]
  correctAnswer: string
  explanation?: string
  order: number
  createdAt: Date
}

export type QuizQuestionType = 'multiple_choice' | 'interactive' | 'pattern' | 'simulation' | 'real_world'

export interface QuizResult {
  id: string
  userId: string
  lessonId: string
  score: number
  answersJson: string
  timeSpent: number
  completedAt: Date
}

export interface Point {
  id: string
  userId: string
  pointsEarned: number
  activityType: ActivityType
  description?: string
  timestamp: Date
}

export type ActivityType = 'video' | 'audio' | 'reading' | 'exercise' | 'quiz' | 'streak'

export interface Exercise {
  id: string
  lessonId: string
  title: string
  type: ExerciseType
  content: string
  solution: string
  pointsValue: number
  order: number
  createdAt: Date
}

export type ExerciseType = 'drag_drop' | 'flowchart' | 'pattern' | 'story' | 'code_blocks'

export interface ExerciseAttempt {
  id: string
  exerciseId: string
  userId: string
  answer: string
  correct: boolean
  attempts: number
  points: number
  completedAt: Date
}

// API and UI specific types
export interface AuthUser {
  id: string
  email: string
  username: string
  avatar?: string
}

export interface LoginCredentials {
  email: string
  password: string
}

export interface SignupCredentials {
  email: string
  username: string
  password: string
  confirmPassword: string
}

export interface UserOnboarding {
  learningGoal: string
  learningStyle: string
  dailyTimeCommitment: string
  avatar: string
}

export interface LessonProgress {
  lesson: Lesson
  progress: UserProgress | null
  quizScore?: number
  exerciseScore?: number
  pointsEarned: number
}

export interface LeaderboardEntry {
  user: User
  totalPoints: number
  weeklyPoints: number
  rank: number
  streak: number
}

export interface QuizAnswers {
  [questionId: string]: string | string[]
}

export interface ExerciseAnswer {
  answer: any
  attempts: number
  timeSpent: number
}

// Component props types
export interface VideoPlayerProps {
  src: string
  onProgress?: (progress: number) => void
  onComplete?: () => void
  subtitles?: string
}

export interface AudioPlayerProps {
  src: string
  onProgress?: (progress: number) => void
  onComplete?: () => void
  title?: string
}

export interface DragDropExerciseProps {
  exercise: Exercise
  onAnswer: (answer: ExerciseAnswer) => void
  onHint?: () => void
}

export interface QuizQuestionProps {
  question: QuizQuestion
  onAnswer: (answer: string | string[]) => void
  showFeedback?: boolean
  userAnswer?: string | string[]
}

export interface PointsDisplayProps {
  points: number
  activity: ActivityType
  timestamp: Date
  description?: string
}

export interface ProgressChartProps {
  data: ProgressData[]
  timeRange: 'week' | 'month' | 'all'
}

export interface ProgressData {
  date: string
  points: number
  lessons: number
  exercises: number
  quizzes: number
}

// Error types
export interface ApiError {
  message: string
  code?: string
  statusCode?: number
}

// Success responses
export interface ApiResponse<T = any> {
  success: boolean
  data?: T
  error?: ApiError
}

// Learning content types
export interface LearningContent {
  videos: VideoContent[]
  audio: AudioContent[]
  reading: ReadingContent[]
  exercises: Exercise[]
  quizQuestions: QuizQuestion[]
}

export interface VideoContent {
  id: string
  title: string
  url: string
  duration: number
  subtitles?: string
  thumbnail?: string
}

export interface AudioContent {
  id: string
  title: string
  url: string
  duration: number
  transcript?: string
}

export interface ReadingContent {
  id: string
  title: string
  content: string
  estimatedReadTime: number
  diagrams?: string[]
}

// Gamification types
export interface Achievement {
  id: string
  title: string
  description: string
  icon: string
  points: number
  unlockedAt?: Date
}

export interface Streak {
  current: number
  longest: number
  lastActiveDate: Date
}

export interface UserStats {
  totalPoints: number
  weeklyPoints: number
  totalLessons: number
  completedLessons: number
  averageQuizScore: number
  currentStreak: number
  longestStreak: number
  achievements: Achievement[]
}