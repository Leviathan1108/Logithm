'use client'

import { useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { useAuthStore } from '@/store/auth'
import { Button } from '@/components/ui/Button'
import {
  BookOpen,
  Trophy,
  Target,
  Flame,
  Clock,
  TrendingUp,
  Play,
  BarChart3,
  User
} from 'lucide-react'
import Link from 'next/link'

export default function DashboardPage() {
  const router = useRouter()
  const { user, isAuthenticated, checkAuth } = useAuthStore()

  useEffect(() => {
    if (!isAuthenticated) {
      router.push('/login?redirect=/dashboard')
      return
    }
  }, [isAuthenticated, router])

  if (!isAuthenticated || !user) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">Loading...</div>
      </div>
    )
  }

  // Mock data - this would come from the API
  const stats = {
    totalPoints: 150,
    weeklyPoints: 45,
    currentStreak: 3,
    longestStreak: 7,
    lessonsCompleted: 5,
    totalLessons: 12,
    averageScore: 85,
    timeSpent: 120 // minutes
  }

  const recentActivity = [
    { id: 1, type: 'lesson', title: 'Sequential Thinking Basics', points: 10, time: '2 hours ago' },
    { id: 2, type: 'quiz', title: 'Quiz: Following Recipes', points: 25, time: '1 day ago' },
    { id: 3, type: 'exercise', title: 'Morning Routine Exercise', points: 15, time: '2 days ago' },
  ]

  const nextLesson = {
    id: 'lesson-2',
    title: 'Branching Logic: Making Decisions',
    description: 'Learn how to use if/else statements through real-world scenarios',
    level: 2,
    estimatedTime: 15
  }

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            Welcome back, {user.username}! 👋
          </h1>
          <p className="text-gray-600">
            Keep up the great work on your algorithm learning journey!
          </p>
        </div>

        {/* Stats Overview */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <div className="bg-white rounded-lg shadow p-6">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <Trophy className="h-8 w-8 text-yellow-500" />
              </div>
              <div className="ml-4">
                <h3 className="text-lg font-medium text-gray-900">Total Points</h3>
                <p className="text-2xl font-bold text-gray-900">{stats.totalPoints.toLocaleString()}</p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow p-6">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <Flame className="h-8 w-8 text-orange-500" />
              </div>
              <div className="ml-4">
                <h3 className="text-lg font-medium text-gray-900">Current Streak</h3>
                <p className="text-2xl font-bold text-gray-900">{stats.currentStreak} days 🔥</p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow p-6">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <BookOpen className="h-8 w-8 text-blue-500" />
              </div>
              <div className="ml-4">
                <h3 className="text-lg font-medium text-gray-900">Lessons Completed</h3>
                <p className="text-2xl font-bold text-gray-900">{stats.lessonsCompleted}/{stats.totalLessons}</p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow p-6">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <Target className="h-8 w-8 text-green-500" />
              </div>
              <div className="ml-4">
                <h3 className="text-lg font-medium text-gray-900">Average Score</h3>
                <p className="text-2xl font-bold text-gray-900">{stats.averageScore}%</p>
              </div>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Next Lesson */}
          <div className="lg:col-span-2">
            <div className="bg-white rounded-lg shadow p-6 mb-6">
              <h2 className="text-xl font-semibold text-gray-900 mb-4">Continue Learning</h2>
              <div className="border-2 border-blue-200 rounded-lg p-4 bg-blue-50">
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <h3 className="text-lg font-medium text-gray-900 mb-2">
                      {nextLesson.title}
                    </h3>
                    <p className="text-gray-600 mb-4">{nextLesson.description}</p>
                    <div className="flex items-center text-sm text-gray-500 space-x-4">
                      <span className="flex items-center">
                        <Clock className="h-4 w-4 mr-1" />
                        {nextLesson.estimatedTime} min
                      </span>
                      <span className="flex items-center">
                        <BarChart3 className="h-4 w-4 mr-1" />
                        Level {nextLesson.level}
                      </span>
                    </div>
                  </div>
                </div>
                <div className="mt-4">
                  <Link href={`/lessons/${nextLesson.id}`}>
                    <Button>
                      <Play className="mr-2 h-4 w-4" />
                      Start Lesson
                    </Button>
                  </Link>
                </div>
              </div>
            </div>

            {/* Recent Activity */}
            <div className="bg-white rounded-lg shadow p-6">
              <h2 className="text-xl font-semibold text-gray-900 mb-4">Recent Activity</h2>
              <div className="space-y-4">
                {recentActivity.map((activity) => {
                  const icons = {
                    lesson: <BookOpen className="h-5 w-5 text-blue-500" />,
                    quiz: <Trophy className="h-5 w-5 text-yellow-500" />,
                    exercise: <Target className="h-5 w-5 text-green-500" />
                  }

                  return (
                    <div key={activity.id} className="flex items-center justify-between py-3 border-b border-gray-200 last:border-0">
                      <div className="flex items-center space-x-3">
                        {icons[activity.type as keyof typeof icons]}
                        <div>
                          <p className="text-sm font-medium text-gray-900">{activity.title}</p>
                          <p className="text-xs text-gray-500">{activity.time}</p>
                        </div>
                      </div>
                      <div className="text-sm font-medium text-gray-900">
                        +{activity.points} pts
                      </div>
                    </div>
                  )
                })}
              </div>
            </div>
          </div>

          {/* Progress Overview */}
          <div className="space-y-6">
            <div className="bg-white rounded-lg shadow p-6">
              <h2 className="text-xl font-semibold text-gray-900 mb-4">Learning Progress</h2>

              <div className="space-y-4">
                <div>
                  <div className="flex justify-between text-sm mb-1">
                    <span className="font-medium text-gray-900">Level 1: Sequential</span>
                    <span className="text-gray-500">100%</span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-2">
                    <div className="bg-green-500 h-2 rounded-full" style={{ width: '100%' }}></div>
                  </div>
                </div>

                <div>
                  <div className="flex justify-between text-sm mb-1">
                    <span className="font-medium text-gray-900">Level 2: Branching</span>
                    <span className="text-gray-500">60%</span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-2">
                    <div className="bg-blue-500 h-2 rounded-full" style={{ width: '60%' }}></div>
                  </div>
                </div>

                <div>
                  <div className="flex justify-between text-sm mb-1">
                    <span className="font-medium text-gray-900">Level 3: Repetition</span>
                    <span className="text-gray-500">0%</span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-2">
                    <div className="bg-gray-400 h-2 rounded-full" style={{ width: '0%' }}></div>
                  </div>
                </div>
              </div>
            </div>

            <div className="bg-white rounded-lg shadow p-6">
              <h2 className="text-xl font-semibold text-gray-900 mb-4">Quick Actions</h2>
              <div className="space-y-3">
                <Link href="/lessons">
                  <Button variant="outline" className="w-full justify-start">
                    <BookOpen className="mr-2 h-4 w-4" />
                    Browse All Lessons
                  </Button>
                </Link>
                <Link href="/leaderboard">
                  <Button variant="outline" className="w-full justify-start">
                    <Trophy className="mr-2 h-4 w-4" />
                    View Leaderboard
                  </Button>
                </Link>
                <Link href="/profile">
                  <Button variant="outline" className="w-full justify-start">
                    <User className="mr-2 h-4 w-4" />
                    Edit Profile
                  </Button>
                </Link>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}