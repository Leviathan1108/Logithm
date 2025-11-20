import { NextRequest, NextResponse } from 'next/server'
import { createUser, AuthError } from '@/lib/auth'
import { SignupCredentials } from '@/types'

export async function POST(request: NextRequest) {
  try {
    const body: SignupCredentials = await request.json()

    const user = await createUser(body)

    return NextResponse.json({
      success: true,
      data: { user }
    }, { status: 201 })

  } catch (error) {
    if (error instanceof AuthError) {
      return NextResponse.json({
        success: false,
        error: { message: error.message, statusCode: error.statusCode }
      }, { status: error.statusCode })
    }

    console.error('Registration error:', error)
    return NextResponse.json({
      success: false,
      error: { message: 'Internal server error', statusCode: 500 }
    }, { status: 500 })
  }
}